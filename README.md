# Multi-Asset Optimization Pre-commit Hook

Automatically optimize all image assets (SVG, PNG, WebP, JPG) in your repository before committing using `svgo` and `caesium-clt`.

## Features

- **Single hook** for all image formats
- **Configurable asset directory** (e.g., `./public`, `./static`, `./assets`)
- **Lossless/Lossy modes** with quality control
- **Recursive optimization** of entire asset directories
- **Minimal dependencies** and lightweight setup
- **Detailed optimization reports**

## Prerequisites

### Required Dependencies

#### SVGO (for SVG optimization)
```bash
# npm
npm install -g svgo

# yarn
yarn global add svgo

# pnpm
pnpm add -g svgo
```

#### Caesium-CLT (for raster image optimization)

**Recommended: Install via Cargo (easiest)**
```bash
cargo install --git https://github.com/Lymphatus/caesium-clt caesiumclt
```

**Alternative installation methods:**

- **macOS**: Download from [GitHub releases](https://github.com/Lymphatus/caesium-clt/releases)
- **Linux**: Download from [GitHub releases](https://github.com/Lymphatus/caesium-clt/releases)  
- **Windows**: Download from [GitHub releases](https://github.com/Lymphatus/caesium-clt/releases)

**Note**: If installing via Cargo, make sure `~/.cargo/bin` is in your PATH:
```bash
export PATH="$HOME/.cargo/bin:$PATH"
```

## Usage

### Basic Setup

Add to your `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/your-username/opt-pre-commit
    rev: v1.0.0
    hooks:
      - id: optimize-assets
        # Default: optimizes ./public directory in lossless mode
```

### Advanced Configuration

```yaml
repos:
  - repo: https://github.com/pde-rent/opt-pre-commit
    rev: v1.0.0
    hooks:
      - id: optimize-assets
        args: 
          - --asset-dir
          - ./static
          - --mode
          - lossy
          - --quality
          - 85
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `--asset-dir` | Directory containing assets to optimize | `./public` |
| `--mode` | Optimization mode: `lossless` or `lossy` | `lossless` |
| `--quality` | Quality level for lossy compression (1-100) | `80` |

### Common Configurations

#### Static Site Generators
```yaml
# For Next.js, Nuxt.js, etc.
- id: optimize-assets
  args: [--asset-dir, ./public]

# For Gatsby
- id: optimize-assets
  args: [--asset-dir, ./static]

# For Hugo
- id: optimize-assets
  args: [--asset-dir, ./static]
```

#### Development vs Production
```yaml
# Development - lossless for quality
- id: optimize-assets
  args: [--asset-dir, ./assets, --mode, lossless]

# Production - lossy for smaller files
- id: optimize-assets
  args: [--asset-dir, ./assets, --mode, lossy, --quality, 85]
```

## Supported File Formats

- **SVG**: `.svg`
- **PNG**: `.png`
- **WebP**: `.webp`
- **JPEG**: `.jpg`, `.jpeg`

## How It Works

1. **Directory Scanning**: Recursively finds all image files in the specified asset directory
2. **Format Detection**: Automatically detects file format and applies appropriate optimization
3. **SVG Optimization**: Uses `svgo` with predefined configuration for consistent results
4. **Raster Optimization**: Uses `caesium-clt` with lossless or lossy compression
5. **Change Detection**: Only modifies files that can be optimized
6. **Staging Requirement**: Fails if files are optimized, requiring you to review and stage changes

## Example Output

```
Optimizing assets in ./public (lossless)
./public/icons/logo.svg - 23% = 441B ✓
./public/images/hero.png - 15% = 142.3KB ✓
./public/images/banner.jpg - no change
Summary: 2/3 files optimized
Please review and stage the changes.
```

## Manual Usage

You can also run the optimization script manually:

```bash
# Optimize ./public directory (lossless)
./scripts/optimize-assets.sh

# Optimize custom directory with lossy compression
./scripts/optimize-assets.sh --asset-dir ./static --mode lossy --quality 85

# Show help
./scripts/optimize-assets.sh --help
```

## Repository Structure

```
opt-pre-commit/
├── .pre-commit-hooks.yaml    # Hook definition
├── scripts/
│   ├── optimize-assets.sh    # Main optimization script
│   └── svgo.config.js       # SVGO configuration
├── tests/
│   ├── test.sh              # Test runner
│   └── fixtures/            # Test assets
├── .github/workflows/       # CI/CD pipeline
├── example/                 # Usage examples
└── README.md               # This file
```

## Development

The repository is designed to be minimal and lightweight:

- **Single hook** handles all image formats
- **No external dependencies** beyond the optimization tools
- **Shell script** for maximum compatibility
- **Configurable** for different project structures

## License

MIT License - Feel free to use in your projects!

## Testing

Run the test suite to verify functionality:

```bash
# Run all tests
npm test

# Or run directly
cd tests && ./test.sh
```

The test suite validates:
- Script syntax and executability
- Help function
- Error handling for invalid directories
- Dependency detection

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `npm test`
5. Test with different asset directories and modes
6. Submit a pull request 