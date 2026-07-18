import { LightningElement } from 'lwc';

export default class ChildB extends LightningElement {

    connectedCallback(){
        this.handleEvent();
    }

    handleEvent(){
        this.dispatchEvent(
            new CustomEvent('childbevent',{
                detail:"This is Child B Message"
            })
        );
    }

}