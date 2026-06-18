import { LightningElement } from 'lwc';

export default class ParentAccountDashboard extends LightningElement {

    // Properties to store data received from the child
    accountName = '';
    accountRating = '';
    accountIndustry = '';
    objectApiName = '';
    hasData = false;

    handleChildSave(event) {
        // Extract the payload sent by the child
        const recordInput = event.detail;

        if (recordInput) {
            this.objectApiName = recordInput.apiName;
            
            // Map the field values using the exact API names sent by the child
            this.accountName = recordInput.fields.Name;
            this.accountRating = recordInput.fields.Rating;
            this.accountIndustry = recordInput.fields.Industry;
            
            // Toggle a flag to show the data block in the HTML
            this.hasData = true;
        }
    }
}