import { LightningElement } from 'lwc';

export default class ParentTabset extends LightningElement {

    message; 

    handleChildEvent(event){
        this.message = event.detail;
    }


    disconnectedCallback(){
        this.message = '';
    }


}