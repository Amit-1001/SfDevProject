import { LightningElement } from 'lwc';

export default class ChildA extends LightningElement {

        connectedCallback(){
            this.handleEvent();
        }

        handleEvent(){
                this.dispatchEvent(
                new CustomEvent('childaevent',{
                    detail:"This is Child A Message"
                })
                );
        }
}