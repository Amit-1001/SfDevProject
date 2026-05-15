import { LightningElement,api } from 'lwc';

export default class LoanForm extends LightningElement {

    loanName = ''
    amount = ''
    customer =''

    handleChangeName(event){
        this.loanName = event.target.value;
    }

    handleChangeAmount(event){
        this.amount = event.target.value;
    }

    handleChangeCustomer(event){
        this.customer = event.target.value;
    }

    @api // called by parent 
    resetForm(){
        this.loanName = '';
        this.amount = '';
        this.customer = '';
    }


    // sending data to parent
    handleSubmit(event){
        const loanData = {
        name: this.loanName,
        amount: this.amount,
        customer: this.customer
    };
        this.dispatchEvent(
            new CustomEvent('create',{
                detail: loanData
            })
        )
    }


}