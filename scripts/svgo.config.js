module.exports = {
  plugins: [
    'cleanupAttrs',
    'removeDoctype',
    'removeXMLProcInst',
    'removeComments',
    'removeMetadata',
    'removeEditorsNSData',
    'cleanupEnableBackground',
    'convertColors',
    'convertPathData',
    'convertTransform',
    'removeUnknownsAndDefaults',
    'removeNonInheritableGroupAttrs',
    'removeUselessStrokeAndFill',
    'removeUnusedNS',
    {
      name: 'cleanupNumericValues',
      params: {
        floatPrecision: 3
      }
    },
    {
      name: 'convertTransform',
      params: {
        floatPrecision: 3
      }
    },
    'cleanupListOfValues',
    'moveElemsAttrsToGroup',
    'moveGroupAttrsToElems',
    'collapseGroups',
    'removeRasterImages',
    'mergePaths',
    'convertShapeToPath',
    'sortAttrs',
    'removeDimensions',
    'removeTitle',
    'removeDesc',
    'removeScriptElement',
    'removeUselessDefs',
    'removeEmptyContainers',
    'removeEmptyText',
    'removeOffCanvasPaths',
    'removeHiddenElems',
    'removeEmptyAttrs',
  ]
} 