import { api, LightningElement, track } from 'lwc';

export default class ApiAndtrack extends LightningElement {

    @api message = 'This is public property @api'

    privateMessage = 'This is private property'
    @track
    dynamicMessage;

    
    handleChange(event){
        this.dynamicMessage = event.target.value;
    }
}