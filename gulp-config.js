/* globals module */

(function () {
  const themeDir = 'docroot/themes/custom/mytheme';
  const paths = {
    js: `${themeDir}/js`,
    sass: `${themeDir}/sass`,
    img: `${themeDir}/img`,
    dist_js: `${themeDir}/dist/js`,
    dist_css: `${themeDir}/dist/css`,
    dist_img: `${themeDir}/dist/img`,
  };

  module.exports = {
    themeDir,
    paths,
    sassOptions: {
      outputStyle: 'expanded',
      eyeglass: {
        enableImportOnce: false,
      },
      drupalSassBreakpoints: {
        themePath: `${themeDir}/`,
      },
    },
  };
}());
