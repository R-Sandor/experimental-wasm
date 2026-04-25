const root = document.getElementById('root');

async function loadCppModule() {
  try {
    root.textContent = 'Loading C++ WASM module...';

    // Load the Emscripten-generated JavaScript module
    const createHelloModule = await import(chrome.runtime.getURL('hello.js'));

    // Initialize the WASM module (factory is default export with ES6)
    const Module = await createHelloModule.default();

    // Create instance of HTMLGenerator class from C++
    const generator = new Module.HTMLGenerator();

    // Get HTML from C++ and display it
    const helloHTML = generator.getHelloHTML();
    root.innerHTML = helloHTML;

    // Add a greeting
    const greeting = generator.createGreeting('Chrome Extension User');
    root.innerHTML += greeting;

    // Add a button with interactivity
    const button = generator.createButton('Click Me!');
    const buttonContainer = document.createElement('div');
    buttonContainer.style.marginTop = '20px';
    buttonContainer.innerHTML = button;
    root.appendChild(buttonContainer);

    // Add click handler to the button
    const buttonElement = buttonContainer.querySelector('button');
    let clickCount = 0;
    buttonElement.addEventListener('click', () => {
      clickCount++;
      // Generate new content from C++ on each click
      const newGreeting = generator.createGreeting(`User (clicked ${clickCount} time${clickCount > 1 ? 's' : ''})`);
      const messageDiv = document.createElement('div');
      messageDiv.innerHTML = newGreeting;
      messageDiv.style.marginTop = '10px';
      messageDiv.style.animation = 'fadeIn 0.3s';
      root.appendChild(messageDiv);
    });

    console.log('C++ WASM module loaded successfully!');

  } catch (e) {
    console.error('Failed to load C++ module:', e);
    root.innerHTML = '<div style="color:red;padding:20px;">' +
                     '<h3>Error Loading Module</h3>' +
                     '<p>' + e.message + '</p>' +
                     '<p><small>Check console for details</small></p>' +
                     '</div>';
  }
}

loadCppModule();

