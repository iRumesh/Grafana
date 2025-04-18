// Load mqtt.js from CDN dynamically
const loadMQTT = () => {
    return new Promise((resolve, reject) => { //wait until the MQTT library is loaded
      if (window.mqtt) return resolve(window.mqtt); //if library is already loaded in the browser, just return it
  
      const script = document.createElement('script');
      script.src = 'https://unpkg.com/mqtt/dist/mqtt.min.js'; //load MQTT client library
      script.onload = () => resolve(window.mqtt);      // once loaded successfully, the promise resolve
      script.onerror = reject;
      document.head.appendChild(script);  // the script is inserted into the <head> of the page
    });
  };
  
  htmlNode.innerHTML = `
    <style>
      .toggle-container {
        display: flex;
        flex-direction: row;
        gap: 40px;
        justify-content: center;
        padding-top: 40px;
      }
      .toggle-group {
        display: flex;
        flex-direction: column;
        align-items: center;
      }
      .switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 34px;
      }
      .switch input {
        opacity: 0;
        width: 0;
        height: 0;
      }
      .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: 0.4s;
        border-radius: 34px;
      }
      .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 4px;
        bottom: 4px;
        background-color: white;
        transition: 0.4s;
        border-radius: 50%;
      }
      input:checked + .slider {
        background-color: rgb(149, 78, 215);
      }
      input:checked + .slider:before {
        transform: translateX(26px);
      }
      .state-text {
        margin-top: 10px;
        font-size: 18px;
        color: white;
      }
      .label {
        color: white;
        font-weight: bold;
        margin-bottom: 5px;
      }
    </style>
  
    <div class="toggle-container">
      <div class="toggle-group">
        <div class="label">Switch 1</div>
        <label class="switch">
          <input type="checkbox" id="ONE">
          <span class="slider"></span>
        </label>
        <div id="stateOne" class="state-text">0</div>
      </div>
  
      <div class="toggle-group">
        <div class="label">Switch 2</div>
        <label class="switch">
          <input type="checkbox" id="TWO">
          <span class="slider"></span>
        </label>
        <div id="stateTwo" class="state-text">0</div>
      </div>
    </div>
  `;
  
  // Once mqtt.js is loaded, connect it into MQTT broker
  loadMQTT().then(() => {
    const client = mqtt.connect('ws://broker.emqx.io:8083/mqtt', {
    // const client = mqtt.connect('ws://test.mosquitto.org:8080/sys', {
      clientId: 'grafana-toggle-' + Math.random().toString(16).substr(2, 8),
      clean: true
    });
  
    client.on('connect', () => {
      console.log(' MQTT connected');
    });
  
    client.on('error', (err) => {
      console.error(' MQTT connection error:', err);
    });
  
    function handleToggle(checkboxId, stateId, topic, storageKey) {
      const checkbox = htmlNode.querySelector(`#${checkboxId}`);
      const stateText = htmlNode.querySelector(`#${stateId}`);
  
      // Load previous state
      const saved = localStorage.getItem(storageKey);
      if (saved === "1") {
        checkbox.checked = true;
        stateText.textContent = "1";
      }
  
      checkbox.addEventListener("change", () => {
        const value = checkbox.checked ? "1" : "0";
        stateText.textContent = value;
        localStorage.setItem(storageKey, value);
  
        client.publish(topic, value, { qos: 2, retain: true }, (err) => {
          if (err) {
            console.error(` Publish to ${topic} failed`, err);
          } else {
            console.log(` Published ${value} to ${topic}`);
          }
        });
      });
    }
  
    // Bind both toggles
    handleToggle("ONE", "stateOne", "topic/ONE", "toggleStateOne");
    handleToggle("TWO", "stateTwo", "topic/TWO", "toggleStateTwo");
  });
  