import React, { useState, useEffect } from "react";
import { supabase } from "../../Supabase/supabaseClient";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../Contexts/AuthContext";

import '../../Styles/Global.css';

const CreateMenu = () => {
     const { user, loading } = useAuth();
     const [recipes, setRecipes] = useState([]);
     const [selectedRecipes, setSelectedRecipes] = useState([]);
     const [menuName, setMenuName] = useState('');
     const [menuDescription, setMenuDescription] = useState('');
     const [error, setError] = useState('');
     const [loadingSubmit, setLoadingSubmit] = useState(false);
     const navigate = useNavigate();

     //Recetas del usuario
     useEffect(() => {
          const fetchRecipes = async () => {
               try {
                    if (!user || !user.usuario_id) {
                         throw new Error('User not authenticated');
                    }
                    const { data: recipesData, error: recipesError } = await supabase
                         .from('recetas')
                         .select('receta_id, nombre')
                         .eq('usuario_id', user.usuario_id);
                    if (recipesError) throw recipesError;
                    setRecipes(recipesData);
               } catch (error) {
                    console.error('Error fetching recipes:', error);
                    setError('Error fetching recipes. Please try again.');
               }
          };

          if (user) fetchRecipes();
     }, [user]);

     const handleRecipeSelect = (receta_id) => {
          setSelectedRecipes((prevSelected) => {
               if (prevSelected.includes(receta_id)) {
                    return prevSelected.filter((id) => id !== receta_id);
               } else {
                    return [...prevSelected, receta_id];
               }
          });
     };

     const handleSubmit = async (e) => {
          e.preventDefault();
          setError('');
          setLoadingSubmit(true);

          try {
               if (!user || !user.usuario_id) {
                    throw new Error('User not authenticated');
               }

               // Insert the new menu
               const { data: menuData, error: menuError } = await supabase
                    .from('menus')
                    .insert({ nombre: menuName, descripcion: menuDescription, usuario_id: user.usuario_id })
                    .select();

               if (menuError) throw menuError;

               const menuId = menuData[0].menu_id;

               // Insert recipes into the Recetas_Menus table
               const menuRecipesData = selectedRecipes.map((receta_id) => ({
                    menu_id: menuId,
                    receta_id,
               }));

               const { error: menuRecipesError } = await supabase
                    .from('recetas_menus')
                    .insert(menuRecipesData);

               if (menuRecipesError) throw menuRecipesError;

               navigate('/');
          } catch (error) {
               console.error('Error creating menu:', error);
               setError('Error creating menu. Please try again.');
          } finally {
               setLoadingSubmit(false);
          }
     };

     if (loading) return <p>Loading...</p>; // Mostrar mensaje de carga si loading es true

     return (
          <div>
               <h2>Crear Nuevo Menú</h2>
               <form onSubmit={handleSubmit}>
                    <input
                         type="text"
                         placeholder="Nombre del Menú"
                         value={menuName}
                         onChange={(e) => setMenuName(e.target.value)}
                         required
                    />
                    <textarea
                         placeholder="Descripción del Menú"
                         value={menuDescription}
                         onChange={(e) => setMenuDescription(e.target.value)}
                         required
                    />
                    <div>
                         <h3>Selecciona Recetas</h3>
                         {recipes.map((recipe) => (
                              <div key={recipe.receta_id}>
                                   <input
                                        type="checkbox"
                                        id={`recipe-${recipe.receta_id}`}
                                        value={recipe.receta_id}
                                        onChange={() => handleRecipeSelect(recipe.receta_id)}
                                   />
                                   <label htmlFor={`recipe-${recipe.receta_id}`}>{recipe.nombre}</label>
                              </div>
                         ))}
                    </div>
                    <button type="submit" disabled={loadingSubmit}>Crear Menú</button>
                    {error && <p>{error}</p>}
               </form>
          </div>
     );
};

export default CreateMenu;