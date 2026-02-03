import { LightningElement, api, track } from 'lwc';

export default class Lwcsearchcomponent extends LightningElement {

  @track searckKeyword;
  @api isrequired = "false";
  @api searchLabel = "Search Account";
  @api showLabel = "true";

  /* Check the isrequired prop is true then set the prop to true
  - If isrequired is the string "true", find the first lightning-input in the component’s template: let picklistInfo = this.template.querySelector("lightning-input");

  - Set its required flag: picklistInfo.required = true; This makes the input field mandatory in the UI/validation.

  - Then immediately flip the component flag: this.isrequired = "false"; This ensures that on the next renderedCallback invocation, 
    the early return triggers and the code won’t run again.

  */
  renderedCallback() {
    if (this.isrequired === "false") return;
    if (this.isrequired === "true") {
      let picklistInfo = this.template.querySelector("lightning-input");
      picklistInfo.required = true;
      this.isrequired = "false"; 
    }
  }

  handleChange(event) {
    var keyword = event.target.value;
    /* Create & dispatch the event to parent component with the search keyword */

    /*Dispatches the custom event from the child component so that a parent component can listen for the "search" event (e.g., onsearch={handleSearch}) and react, 
      typically by initiating a search/filter using the provided keyword.
    */
    if (keyword && keyword.length >= 2) {
      let searchEvent = new CustomEvent("search", {
        detail: { value: keyword }
      });
      this.dispatchEvent(searchEvent);
    }
  }
}