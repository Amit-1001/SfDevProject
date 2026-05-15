import { api, LightningElement } from 'lwc';

export default class LoanRow extends LightningElement {

    @api loan;
    @api isLoading;

    handleApprove(){
        this.dispatchEvent(
            new CustomEvent('approve', { // sending CustomEvent to Parent
                detail: this.loan.Id
            })
        );
    }

    handleReject(){
        this.dispatchEvent(
            new CustomEvent('reject',{
                detail:this.loan.Id
            })
        )
    }

}