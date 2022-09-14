import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';

const dummyCars = [
  Car(
      id: '1',
      model: 'Ka',
      imageUrl:
          'https://2.bp.blogspot.com/-tcCwlEwU0Hc/U9J6_6l0ITI/AAAAAAABbH8/6l7FOq6lrIU/s1600/Novo-Ford-Ka-2015+(2).jpg',
      price: 199.99,
      review: 4.5,
      brand: 'Ford',
      category: CarCategory.hatchback,
      color: 'Preto',
      doors: 2,
      fuel: CarFuel.petrol,
      gearShift: CarGearShift.manual,
      plate: 'FUU0C47',
      seats: 5,
      trunk: 50,
      userId: 1,
      year: 2012,
      description:
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy\n text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.\n It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.\n\n It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'),
  Car(
    id: '2',
    model: 'Argo',
    imageUrl:
        'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjBeSC8rsRqCHliDIA9OW8pAuhC0fIYfEbJ82rJnuz-4vvJtGl-jr5LJk-29BYbNILnREDIK72oLg53NfIy87JMuj8kEeA5ZppUo2WEkrp5jUEERl6wJoowB6pkwZ9QuCmzvVhD4qHgQP97RCdkydgmio3zX0RfoCRFpn9Iuojdom4Cpm1b8ErE_xXuDw/s600/Novo-Argo-2023%20%283%29.jpg',
    price: 159.75,
    review: 3,
    brand: 'Fiat',
    category: CarCategory.hatchback,
    color: 'Preto',
    doors: 4,
    fuel: CarFuel.petrol,
    gearShift: CarGearShift.manual,
    plate: 'FDA0C48',
    seats: 5,
    trunk: 50,
    userId: 1,
    year: 2016,
  ),
  Car(
      id: '3',
      model: 'Corolla',
      imageUrl:
          'https://motorshow.com.br/wp-content/uploads/sites/2/2022/06/29-toyota-corolla-747x420.jpg',
      price: 359.75,
      review: 5,
      brand: 'Toyota',
      category: CarCategory.sedan,
      color: 'Branco',
      doors: 4,
      fuel: CarFuel.petrol,
      gearShift: CarGearShift.automatic,
      plate: 'FDG2C58',
      seats: 5,
      trunk: 300,
      userId: 2,
      year: 2023,
      description: 'Baita carro de tiozão, muito bom tbm.')
];
