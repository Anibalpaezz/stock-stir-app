import React, { useEffect, useState } from 'react';
import { supabase } from '../Supabase/supabaseClient';
import '../Styles/ProductList.css';

const ProductList = () => {
     const [products, setProducts] = useState([]);

     useEffect(() => {
          const fetchProducts = async () => {
               const { data, error } = await supabase
                    .from('productos')
                    .select('producto_id, nombre, precio, foto');

               if (error) console.error('Error fetching products:', error);
               else setProducts(data);
          };

          fetchProducts();
     }, []);

     return (
          <div className="product-list">
               {products.map(product => (
                    <div className="product-card" key={product.producto_id}>
                         <img src={product.foto} alt={product.nombre} className="product-image" />
                         <h2 className="product-name">{product.nombre}</h2>
                         <p className="product-price">${product.precio}</p>
                    </div>
               ))}
          </div>
     );
};

export default ProductList;