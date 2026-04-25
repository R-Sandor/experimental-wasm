// Module configuration for Emscripten
var Module = {
  preRun: [],
  postRun: [],
  print: function(text) {
    text = Array.prototype.slice.call(arguments).join(' ');
    console.log(text);
  },
  printErr: function(text) {
    text = Array.prototype.slice.call(arguments).join(' ');
    // Filter out known harmless warnings for extension context
    if (text.includes('glfwSetWindowIcon') ||
        text.includes('glfwSetWindowAttrib') ||
        text.includes('Invalid WebGL version') ||
        text.includes('emscripten_set_main_loop_timing')) {
      return; // Suppress these warnings
    }
    console.error(text);
  },
  canvas: (function() {
    var canvas = document.getElementById('canvas');

    // Prevent context menu on canvas
    canvas.addEventListener('contextmenu', function(e) {
      e.preventDefault();
    }, false);

    canvas.addEventListener('webglcontextlost', function(e) {
      alert('WebGL context lost. Please reload the extension.');
      e.preventDefault();
    }, false);

    // Try WebGL2 first, fall back to WebGL1
    var contextAttributes = { stencil: true };
    var context = canvas.getContext('webgl2', contextAttributes);

    if (!context) {
      console.warn('WebGL 2 not available, falling back to WebGL 1');
      context = canvas.getContext('webgl', contextAttributes);
    }

    if (!context) {
      alert('WebGL not available in this browser');
    }

    return canvas;
  })(),
  setStatus: function(text) {
    var statusElement = document.getElementById('status');
    if (text) {
      console.log('Status: ' + text);
      statusElement.textContent = text;
    } else {
      statusElement.style.display = 'none';
    }
  },
  monitorRunDependencies: function(left) {
    console.log('Run dependencies: ' + left);
  },
  // Customize locateFile to use chrome.runtime.getURL for extension resources
  locateFile: function(path, prefix) {
    // For extension, use chrome.runtime.getURL to get the correct path
    return chrome.runtime.getURL(path);
  }
};

window.onerror = function(event) {
  console.error('Error: ' + event);
};

// Load the Emscripten-generated JavaScript
var script = document.createElement('script');
script.src = chrome.runtime.getURL('hello_world_.js');
script.async = true;
document.body.appendChild(script);
