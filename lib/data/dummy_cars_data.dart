import 'package:carshare/models/auth.dart';
import 'package:carshare/models/car.dart';

const dummyCars = [
  Car(
    id: '1',
    model: 'Ka',
    imageUrl:
        'https://2.bp.blogspot.com/-tcCwlEwU0Hc/U9J6_6l0ITI/AAAAAAABbH8/6l7FOq6lrIU/s1600/Novo-Ford-Ka-2015+(2).jpg',
    price: 199.99,
    review: 4,
    brand: 'Ford',
    category: Category.hatchback,
    color: 'Preto',
    doors: 2,
    fuel: Fuel.petrol,
    gearShift: GearShift.manual,
    plate: 'FUU0C47',
    seats: 5,
    trunk: 50,
    userId: 1,
    year: 2012,
  ),
  Car(
    id: '2',
    model: 'Argo',
    imageUrl:
        'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjBeSC8rsRqCHliDIA9OW8pAuhC0fIYfEbJ82rJnuz-4vvJtGl-jr5LJk-29BYbNILnREDIK72oLg53NfIy87JMuj8kEeA5ZppUo2WEkrp5jUEERl6wJoowB6pkwZ9QuCmzvVhD4qHgQP97RCdkydgmio3zX0RfoCRFpn9Iuojdom4Cpm1b8ErE_xXuDw/s600/Novo-Argo-2023%20%283%29.jpg',
    price: 359.75,
    review: 3,
    brand: 'Fiat',
    category: Category.hatchback,
    color: 'Preto',
    doors: 4,
    fuel: Fuel.petrol,
    gearShift: GearShift.manual,
    plate: 'FDA0C48',
    seats: 5,
    trunk: 50,
    userId: 1,
    year: 2012,
  )
];
