import React, {useState, useEffect} from "react";
import { supabase } from '../../Supabase/supabaseClient';
import { useNavigate } from "react-router-dom";

const CreateRecipe = () => {
     const [nombre, setNombre] = useState('');
     const [descripcion, setDescripcion] = useState('');
     const [numIngredients, setNumIngredients] = useState(0);
     const [ingredients, setIngredients] = useState([]);
     const [productos, setProductos] = useState([]);
     const [error, setError] = useState('');
     const navigate = useNavigate();

     useEffect(() => {
          const fetchProductos = async () => {
               const { data: productosData, error: productosError } = await supabase
                    .from('productos')
                    .select('producto_id, nombre');
               if (productosError) {
                    console.error('Error fetching productos:', productosError);
               } else {
                    setProductos(productosData);
               }
          };

          fetchProductos();
     }, []);

     const handleNumIngredientsChange = (e) => {
          const value = parseInt(e.target.value);
          setNumIngredients(value);
          setIngredients(Array(value).fill({ producto_id: '', cantidad_requerida: '' }));
     };

     const handleIngredientChange = (index, field, value) => {
          const newIngredients = [...ingredients];
          newIngredients[index] = {
               ...newIngredients[index],
               [field]: value
          };
          setIngredients(newIngredients);
     };

     const handleSubmit = async (e) => {
          e.preventDefault();
          setError('');

          try {
               // Insert the new recipe
               const { data: recetaData, error: recetaError } = await supabase
                    .from('recetas')
                    .insert({ nombre, descripcion, usuario_id: 1 }) // Assuming user_id is 1 for simplicity
                    .select();

               if (recetaError) {
                    throw recetaError;
               }

               const recetaId = recetaData[0].receta_id;

               // Insert ingredients
               const ingredientsData = ingredients.map(ingredient => ({
                    nombre: productos.find(p => p.producto_id === parseInt(ingredient.producto_id)).nombre,
                    receta_id: recetaId,
                    producto_id: parseInt(ingredient.producto_id),
                    cantidad_requerida: ingredient.cantidad_requerida
               }));

               const { error: ingredientsError } = await supabase
                    .from('ingredientes')
                    .insert(ingredientsData);

               if (ingredientsError) {
                    throw ingredientsError;
               }

               navigate('/');
          } catch (error) {
               console.error('Error creating recipe:', error);
               setError('Error creating recipe. Please try again.');
          }
     };

     return (
          <div>
               <h2>Crear Nueva Receta</h2>
               <form onSubmit={handleSubmit}>
                    <input
                         type="text"
                         placeholder="Nombre"
                         value={nombre}
                         onChange={(e) => setNombre(e.target.value)}
                         required
                    />
                    <textarea
                         placeholder="Descripción"
                         value={descripcion}
                         onChange={(e) => setDescripcion(e.target.value)}
                         required
                    />
                    <input
                         type="number"
                         placeholder="Número de ingredientes"
                         value={numIngredients}
                         onChange={handleNumIngredientsChange}
                         required
                    />
                    {Array.from({ length: numIngredients }).map((_, index) => (
                         <div key={index}>
                              <select
                                   onChange={(e) => handleIngredientChange(index, 'producto_id', e.target.value)}
                                   required
                              >
                                   <option value="">Selecciona un producto</option>
                                   {productos.map(producto => (
                                        <option key={producto.producto_id} value={producto.producto_id}>
                                             {producto.nombre}
                                        </option>
                                   ))}
                              </select>
                              <input
                                   type="text"
                                   placeholder="Cantidad requerida"
                                   onChange={(e) => handleIngredientChange(index, 'cantidad_requerida', e.target.value)}
                                   required
                              />
                         </div>
                    ))}
                    <button type="submit">Enviar</button>
               </form>
               {error && <p>{error}</p>}
          </div>
     );
};

export default CreateRecipe;