import { LightningElement, track } from 'lwc';

export default class LwcConditionalComponent extends LightningElement {

    isTrue = false;

    @track
    userRecords = ['Amit','Mandar','Sachin','Rahul']

    handleClick(){
        if(this.isTrue == true){
            this.isTrue = false;
        }else{
            this.isTrue = true
        }
    }


}