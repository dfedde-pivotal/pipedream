// pull in desired CSS/SASS files
require( './styles/main.scss' );
yaml = require('js-yaml');
var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed 

// inject bundled Elm app into div#main
var Elm = require( '../elm/Main' );
elm = Elm.Main.embed( document.getElementById( 'main' ) );

elm.ports.toYAML.subscribe(function(e) { console.log(yaml.safeDump(e)); });
