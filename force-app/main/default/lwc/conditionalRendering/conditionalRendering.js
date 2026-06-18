import { LightningElement } from 'lwc';

export default class ConditionalRendering extends LightningElement {

    isMessageVisible = false;

    handleChange(event){
        this.isMessageVisible = event.target.checked;
    }

}