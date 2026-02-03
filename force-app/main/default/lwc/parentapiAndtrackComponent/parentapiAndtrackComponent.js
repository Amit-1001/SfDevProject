import { LightningElement } from 'lwc';

export default class ParentapiAndtrackComponent extends LightningElement {

    updateProperty(event){
        this.template.querySelector('c-api-andtrack').myName = event.target.value; // this is how we can update the child component property from parent component
    }
}