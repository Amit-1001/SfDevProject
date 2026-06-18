import { LightningElement } from 'lwc';

export default class ParentMessage extends LightningElement {

    message = ''

    handleChange(event){
        
        this.message = event.target.value;
    }

}