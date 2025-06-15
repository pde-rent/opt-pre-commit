#!/bin/bash

# Default values
ASSET_DIR="./public"
MODE="lossless"
QUALITY=80
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --asset-dir)
      ASSET_DIR="$2"
      shift 2
      ;;
    --mode)
      MODE="$2"
      shift 2
      ;;
    --quality)
      QUALITY="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  --asset-dir DIR    Directory containing assets to optimize (default: ./public)"
      echo "  --mode MODE        Optimization mode: lossless or lossy (default: lossless)"
      echo "  --quality QUALITY  Quality for lossy compression (default: 80)"
      echo "  -h, --help         Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Validate asset directory
if [[ ! -d "$ASSET_DIR" ]]; then
    echo "Error: Asset directory '$ASSET_DIR' does not exist."
    exit 1
fi

# Check dependencies
check_dependencies() {
    local missing=()
    
    if ! command -v svgo &> /dev/null; then
        missing+=("svgo (install with: npm install -g svgo)")
    fi
    
    if ! command -v caesiumclt &> /dev/null; then
        missing+=("caesiumclt (install from: https://github.com/Lymphatus/caesium-clt)")
    fi
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Error: Missing required dependencies:"
        printf '  - %s\n' "${missing[@]}"
        exit 1
    fi
}

# Optimize SVG files
optimize_svg() {
    local file="$1"
    
    # Create backup
    cp "$file" "$file.backup"
    
    # Optimize using the config and parse output
    svgo --config "$SCRIPT_DIR/svgo.config.js" "$file" 2>/dev/null | \
    awk -v filename="$file" '
        # Process size lines
        /KiB/ {
            # Extract initial size
            initial_size = $1
            
            # Extract percentage if present
            if ($3 == "-" && $4 ~ /%/) {
                percentage = $4
                final_size = $6
            } else {
                percentage = "0%"
                final_size = initial_size
            }
            
            # Convert KiB to KB
            initial_kb = substr(initial_size, 1, length(initial_size)-3) * 1.024
            final_kb = substr(final_size, 1, length(final_size)-3) * 1.024
            
            # Print result with appropriate size format
            if (percentage != "0%") {
                if (final_kb < 1.0) {
                    printf "%s - %s = %dB ✓\n", filename, percentage, int(final_kb * 1024)
                } else {
                    printf "%s - %s = %.1fKB ✓\n", filename, percentage, final_kb
                }
            }
        }
    '
    
    # Check if file was actually modified
    if ! cmp -s "$file" "$file.backup"; then
        rm "$file.backup"
        return 0
    else
        echo "$file - no change"
        rm "$file.backup"
        return 1
    fi
}

# Optimize raster images
optimize_raster() {
    local file="$1"
    
    # Create backup and get initial size
    cp "$file" "$file.backup"
    local initial_size=$(stat -f%z "$file.backup" 2>/dev/null || stat -c%s "$file.backup" 2>/dev/null)
    
    # Optimize based on mode
    if [[ "$MODE" == "lossy" ]]; then
        caesiumclt -q "$QUALITY" -o "$(dirname "$file")/" "$file" >/dev/null 2>&1
    else
        caesiumclt --lossless -o "$(dirname "$file")/" "$file" >/dev/null 2>&1
    fi
    
    # Check if file was actually modified
    if ! cmp -s "$file" "$file.backup"; then
        local final_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        local reduction=$(( (initial_size - final_size) * 100 / initial_size ))
        
        if [[ $reduction -gt 0 ]]; then
            if [[ $final_size -lt 1024 ]]; then
                echo "$file - ${reduction}% = ${final_size}B ✓"
            else
                local final_kb=$(echo "scale=1; $final_size / 1024" | bc 2>/dev/null || echo $(( final_size / 1024 )))
                echo "$file - ${reduction}% = ${final_kb}KB ✓"
            fi
        else
            echo "$file - no change"
        fi
        rm "$file.backup"
        return 0
    else
        echo "$file - no change"
        rm "$file.backup"
        return 1
    fi
}

# Main execution
main() {
    echo "Optimizing assets in $ASSET_DIR ($MODE$([ "$MODE" = "lossy" ] && echo " q$QUALITY"))"
    
    check_dependencies
    
    local modified=false
    local total_files=0
    local optimized_files=0
    
    # Find and process all image files
    while IFS= read -r -d '' file; do
        ((total_files++))
        
        case "${file##*.}" in
            svg)
                if optimize_svg "$file"; then
                    modified=true
                    ((optimized_files++))
                fi
                ;;
            png|webp|jpg|jpeg)
                if optimize_raster "$file"; then
                    modified=true
                    ((optimized_files++))
                fi
                ;;
        esac
    done < <(find "$ASSET_DIR" -type f \( -iname "*.svg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0)
    
    echo "Summary: $optimized_files/$total_files files optimized"
    
    if [[ "$modified" == true ]]; then
        echo "Please review and stage the changes."
        exit 1
    fi
}

main 