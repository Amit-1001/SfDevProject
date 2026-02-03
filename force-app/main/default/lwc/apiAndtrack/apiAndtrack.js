import { api, LightningElement } from 'lwc';

export default class ApiAndtrack extends LightningElement {

    @api myName = 'This is Child Component value'

    updateProperty(event){
        this.myName = event.target.value;
    }

}