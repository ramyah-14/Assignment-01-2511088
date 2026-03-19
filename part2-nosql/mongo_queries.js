// ============================================================
// mongo_queries.js
// MongoDB operations for the product catalog
// Run in Mongosh: mongosh < mongo_queries.js
// ============================================================

// Use (or create) the ecommerce database
use("ecommerce");

// ============================================================
// OP1: insertMany() — insert all 3 documents from sample_documents.json
// ============================================================
db.products.insertMany([
  {
    _id: "prod_elec_001",
    category: "Electronics",
    product_name: "Sony WH-1000XM5 Wireless Headphones",
    brand: "Sony",
    sku: "SNY-WH1000XM5-BLK",
    price: 29999,
    currency: "INR",
    stock_quantity: 45,
    specifications: {
      battery_life_hours: 30,
      connectivity: ["Bluetooth 5.2", "3.5mm jack", "USB-C"],
      noise_cancellation: true,
      water_resistance: "IPX4",
      voltage: "5V DC",
      warranty_years: 1,
      weight_grams: 250,
      color_options: ["Black", "Platinum Silver"]
    },
    ratings: { average: 4.6, total_reviews: 1832 },
    tags: ["wireless", "noise-cancelling", "premium", "audio"],
    created_at: new Date("2024-01-15T10:00:00Z")
  },
  {
    _id: "prod_cloth_002",
    category: "Clothing",
    product_name: "Cotton Anarkali Kurti",
    brand: "FabIndia",
    sku: "FBI-KURTI-ANR-L-RED",
    price: 1499,
    currency: "INR",
    stock_quantity: 120,
    specifications: {
      fabric: "100% Cotton",
      sizes_available: ["XS", "S", "M", "L", "XL", "XXL"],
      color: "Red with gold block print",
      care_instructions: ["Machine wash cold", "Do not bleach", "Tumble dry low"],
      occasion: ["Casual", "Festive"],
      sleeve_type: "3/4 Sleeve",
      pattern: "Block Print",
      country_of_origin: "India"
    },
    ratings: { average: 4.3, total_reviews: 542 },
    tags: ["kurti", "cotton", "ethnic", "women", "festive"],
    created_at: new Date("2024-02-20T08:30:00Z")
  },
  {
    _id: "prod_groc_003",
    category: "Groceries",
    product_name: "India Gate Basmati Rice Premium",
    brand: "India Gate",
    sku: "IGATE-BASMATI-5KG",
    price: 649,
    currency: "INR",
    stock_quantity: 300,
    specifications: {
      weight_kg: 5,
      grain_type: "Long Grain Basmati",
      organic: false,
      expiry_date: new Date("2025-12-31"),
      manufacturing_date: new Date("2024-06-01"),
      storage_instructions: "Store in a cool, dry place away from direct sunlight",
      nutritional_info: {
        per_100g: {
          calories_kcal: 356,
          carbohydrates_g: 79,
          protein_g: 7.5,
          fat_g: 0.6,
          fibre_g: 0.4,
          sodium_mg: 5
        }
      },
      fssai_license: "10019022002269",
      allergens: ["None"]
    },
    ratings: { average: 4.5, total_reviews: 3204 },
    tags: ["rice", "basmati", "staple", "grains", "5kg"],
    created_at: new Date("2024-06-01T06:00:00Z")
  }
]);

// ============================================================
// OP2: find() — retrieve all Electronics products with price > 20000
// ============================================================
db.products.find(
  {
    category: "Electronics",
    price: { $gt: 20000 }
  },
  { product_name: 1, brand: 1, price: 1, category: 1 }
);

// ============================================================
// OP3: find() — retrieve all Groceries expiring before 2025-01-01
// ============================================================
db.products.find(
  {
    category: "Groceries",
    "specifications.expiry_date": { $lt: new Date("2025-01-01") }
  },
  { product_name: 1, "specifications.expiry_date": 1 }
);

// ============================================================
// OP4: updateOne() — add a "discount_percent" field to a specific product
// Adding a 10% discount to the Sony Headphones (prod_elec_001)
// ============================================================
db.products.updateOne(
  { _id: "prod_elec_001" },
  {
    $set: {
      discount_percent: 10,
      discounted_price: 26999
    }
  }
);

// ============================================================
// OP5: createIndex() — create an index on the category field
// Reason: The most common query pattern for a product catalog is
// filtering by category (e.g., show all Electronics). Without an
// index, MongoDB performs a full collection scan on every such query.
// A single-field index on "category" allows the query engine to
// jump directly to matching documents, dramatically reducing
// response time as the catalog grows to thousands of products.
// ============================================================
db.products.createIndex(
  { category: 1 },
  { name: "idx_category_asc", background: true }
);
