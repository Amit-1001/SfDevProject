import { LightningElement } from 'lwc';

export default class LoanContainer extends LightningElement {

    loans = [];

    handleCreateLoan(event){
        const data = event.detail; // detail coming from child component

        // spread  operator ...
        this.loans = [
            ...this.loans,{
                Name: data.name,
                Loan_Amount__c: data.amount,
                Customer__r: { Name: data.customer}
            }
        ];
    }

    handleReset(){
        const form = this.template.querySelector('c-loan-form');
        form.resetForm(); // calling child method

        //Resetting UI
        const inputs = this.template.querySelectorAll('lightning-input');
        inputs.forEach(input => {
            input.value = null;
        });
    }
}