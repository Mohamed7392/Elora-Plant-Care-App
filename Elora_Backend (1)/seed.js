const mongoose = require('mongoose');
const Product = require('./models/Product');
require('dotenv').config();

const dummyPlants = [
  {
    name: 'Monstera Deliciosa',
    description: 'A beautiful tropical plant with iconic split leaves. Perfect for bright indirect light.',
    price: 35.99,
    category: 'Indoor',
    imageUrl: 'assets/images/monstera.png',
    stock: 20
  },
  {
    name: 'Snake Plant',
    description: 'One of the easiest plants to care for. Needs very little water and low light.',
    price: 18.50,
    category: 'Succulents',
    imageUrl: 'assets/images/snake_plant.png',
    stock: 50
  },
  {
    name: 'Fiddle Leaf Fig',
    description: 'A popular indoor tree with large, violin-shaped leaves.',
    price: 45.00,
    category: 'Indoor',
    imageUrl: 'assets/images/fiddle_leaf.png',
    stock: 15
  },
  {
    name: 'Golden Pothos',
    description: 'A fast-growing trailing vine. Perfect for hanging baskets.',
    price: 12.99,
    category: 'Indoor',
    imageUrl: 'assets/images/golden_pothos.png',
    stock: 100
  },
  {
    name: 'Peace Lily',
    description: 'Beautiful white blooms and dark green leaves. Known for air purification.',
    price: 24.99,
    category: 'Outdoor',
    imageUrl: 'assets/images/peace_lily.png',
    stock: 30
  },
  {
    name: 'Aloe Vera',
    description: 'A medicinal succulent that loves bright sunlight.',
    price: 14.99,
    category: 'Succulents',
    imageUrl: 'assets/images/aloe_vera.png',
    stock: 40
  }
];

mongoose.connect('mongodb://127.0.0.1:27017/shop').then(async () => {
  console.log('MongoDB Connected to seed data...');
  
  // Clear existing products to prevent duplicates during testing
  await Product.deleteMany({});
  
  // Insert dummy plants
  await Product.insertMany(dummyPlants);
  
  console.log('Successfully seeded database with beautiful plants!');
  mongoose.disconnect();
}).catch(err => {
  console.error('Failed to connect to MongoDB', err);
});
