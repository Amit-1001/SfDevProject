import { api, LightningElement } from 'lwc';

export default class ChildSumForm extends LightningElement {

    @api
    sum;
    
    a=0;
    b=0;

    handleSum(){

        // Convert the values to Numbers immediately
        this.a = Number(this.template.querySelector('.num1').value);
        this.b = Number(this.template.querySelector('.num2').value);

        this.dispatchEvent(
            new CustomEvent('sum',{
                detail:[this.a,this.b]
            })
        );
    }



}