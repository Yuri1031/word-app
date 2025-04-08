import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="color"
export default class extends Controller {
  static targets = ["layer", "input", "button"];
  connect() {
    console.log("color_controller.js connected!")
    console.log("Targets:", {
      layer: this.hasLayerTarget,
      input: this.hasInputTarget,
      button: this.hasButtonTarget
    })
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickListener.bind(this));
  }

  toggleMenu(event) {
    event.preventDefault();
    event.stopPropagation();

    const isOpen = this.layerTarget.classList.contains("dropdown__menu-layer--show");
  
    if (isOpen) {
      this.closeMenu();
    } else {
      this.layerTarget.classList.add("dropdown__menu-layer--show");

      this.outsideClickListenerRef = this.outsideClickListener.bind(this);
      document.addEventListener("click", this.outsideClickListenerRef);
    }
    
  }

  closeMenu(event) {
    event.stopPropagation();
    this.layerTarget.classList.remove("dropdown__menu-layer--show");
    document.removeEventListener("click", this.outsideClickListener.bind(this));
  }

  select(event) {
    const selectedElement = event.currentTarget;
    const colorId = selectedElement.dataset.colorId;

    this.inputTarget.value = colorId;
    this.buttonTarget.innerText = ``;

    const allOptions = this.element.querySelectorAll(".color-option");
    allOptions.forEach(el => el.classList.remove("dropdown__item--active"));
    selectedElement.classList.add("dropdown__item--active");

    this.layerTarget.classList.remove("dropdown__menu-layer--show");

    this.buttonTarget.style.backgroundColor = selectedElement.style.backgroundColor;
  }

  outsideClickListener(event) {
    if (!this.element.contains(event.target)) {
      this.layerTarget.classList.remove("dropdown__menu-layer--show");
    }
  }
  
}
