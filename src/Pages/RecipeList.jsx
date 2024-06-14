import React, { useEffect, useState } from "react";
import { supabase } from "../Supabase/supabaseClient";
import { useAuth } from "../Contexts/AuthContext";
import { Link } from "react-router-dom";


import '../Styles/RecipeList.css';
import '../Styles/Global.css';

const RecipeList = () => {
     const [recipes, setRecipes] = useState([]);
     const { user } = useAuth();

     useEffect(() => {
          const fetchRecipes = async () => {
               // Obtener las recetas
               const { data: recipesData, error: recipesError } = await supabase
                    .from('recetas')
                    .select('receta_id, nombre, descripcion');

               if (recipesError) {
                    console.error('Error fetching recipes:', recipesError);
                    return;
               }

               // Obtener los ingredientes para cada receta
               const recipesWithIngredients = await Promise.all(
                    recipesData.map(async recipe => {
                         const { data: ingredientsData, error: ingredientsError } = await supabase
                              .from('ingredientes')
                              .select('ingrediente_id, nombre, cantidad_requerida')
                              .eq('receta_id', recipe.receta_id);

                         if (ingredientsError) {
                              console.error('Error fetching ingredients for recipe:', recipe.receta_id, ingredientsError);
                              return recipe;
                         }

                         return {
                              ...recipe,
                              ingredients: ingredientsData,
                         };
                    })
               );

               setRecipes(recipesWithIngredients);
          };

          fetchRecipes();
     }, []);

     return (
          <>
          <div>
               {user && (
                    <Link to="/crear-receta"><button>Crear Receta</button></Link>
               )}
          </div>
          <div className="recipe-list">
               {recipes.map(recipe => (
                    <div className="recipe-card" key={recipe.receta_id}>
                         <h2 className="recipe-name">{recipe.nombre}</h2>
                         <p className="recipe-description">{recipe.descripcion}</p>
                         <ul className="recipe-ingredients">
                              {recipe.ingredients.map(ingredient => (
                                   <li key={ingredient.ingrediente_id}>
                                        {ingredient.nombre} - {ingredient.cantidad_requerida}
                                   </li>
                              ))}
                         </ul>
                    </div>
               ))}
          </div>
          </>
     );
};

export default RecipeList;