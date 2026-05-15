import { api, LightningElement } from 'lwc';

export default class ParentAdditionDashboard extends LightningElement {

    numbers =[];
    
    sum=0;

    handleCalculation(event){
        this.numbers = event.detail;

        if(this.numbers){
            this.sum = this.numbers[0]+this.numbers[1];
        }

        
    }

}