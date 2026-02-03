import { LightningElement } from 'lwc';
import images from '@salesforce/resourceUrl/FightClubCarousel'; // importing images from Static Resource
export default class ImageCarousel extends LightningElement {

    //Getting this three images from Static Resource
    carouselImage1 = images+ "/Carousel1.jpg";
    carouselImage2 = images + "/Carousel2.jpg";
    carouselImage3 = images + "/Carousel3.jpg";
}