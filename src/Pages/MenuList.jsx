import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";

import { supabase } from "../Supabase/supabaseClient";
import { useAuth } from "../Contexts/AuthContext";

import '../Styles/MenuList.css';
import '../Styles/Global.css';

const MenuList = () => {
     const [menus, setMenus] = useState([]);
     const { user } = useAuth(); // Solo necesitamos el usuario autenticado

     useEffect(() => {
          const fetchMenus = async () => {
               try {
                    // Obtener los menús desde Supabase
                    const { data: menusData, error: menusError } = await supabase
                         .from('menus')
                         .select('menu_id, nombre, descripcion');

                    if (menusError) {
                         console.error('Error fetching menus:', menusError);
                         return;
                    }

                    setMenus(menusData);
               } catch (error) {
                    console.error('Error fetching menus:', error.message);
               }
          };

          fetchMenus();
     }, []);

     return (
          <div className="menu-list">
               {user && (
                    <Link to="/crear-menu"><button>Crear Menú</button></Link>
               )}
               {menus.map(menu => (
                    <div className="menu-card" key={menu.menu_id}>
                         <h2 className="menu-name">{menu.nombre}</h2>
                         {menu.descripcion && <p className="menu-description">{menu.descripcion}</p>}
                    </div>
               ))}
          </div>
     );
};

export default MenuList;
