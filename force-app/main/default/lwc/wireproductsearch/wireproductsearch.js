import { LightningElement, track, wire } from 'lwc';
import searchProduct from '@salesforce/apex/BookingLWCHelper.searchProduct';
export default class Wirebookingsearch extends LightningElement {

    @track productName = '';

    products

    handleChange(event){
        this.productName = event.target.value;
    }

    @wire(searchProduct, {productName:'$productName'})
    wiredProducts({data,error}){
        if(data){
            this.products = data
            console.log("Product Data:",data);
        }else if(error){
            console.error(error);
        }
    }


}