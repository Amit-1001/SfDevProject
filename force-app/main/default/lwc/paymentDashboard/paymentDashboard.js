import { LightningElement, api } from 'lwc';
import createPaymentSession from '@salesforce/apex/PaymentGatewayService.createPaymentSession';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class PaymentDashboard extends LightningElement {
    @api recordId;

    isLoading = false;

    handlePayment(){
        this.isLoading = true;

        createPaymentSession({loanId: this.recordId})
        .then(paymentUrl=>{
            // Redirect User
            console.log('PaymentURL'+paymentUrl);
            window.open(
                paymentUrl,
                '_blank'
            );
        }).catch(error =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title:'Error',
                    message:error.body.message,
                    variant:'error'

                })
            )
        }).finally(()=>{
            this.isLoading = false;
        })
    }
    


}