import React from 'react';

import '../Styles/Home.css';
import '../Styles/Global.css';

import alfredo from '../Photos/pasta-alfredo.jpg';
import tortilla from  '../Photos/tortilla-española.jpg';
import logo from "../Photos/Logo-SS-ampliado.jpg";

const Home = () => {
     return (
          <div className="home-container">
               <header className="header">
                    <h1>Bienvenido a Stock & Stir</h1>
                    <p>Tu gestor de stock doméstico ideal</p>
               </header>

               <section className="about">
                    <h2>Sobre Nosotros</h2>
                    <p>En Stock & Stir, te ayudamos a gestionar tus productos alimenticios y a planificar tus menús de manera eficiente.
                         Nuestra plataforma permite crear y guardar recetas, así como llevar un control de tu inventario doméstico.</p>
                         <img src={logo} alt="Nuestro logo" />
               </section>

               <section className="features">
                    <h2>Características</h2>
                    <ul>
                         <li>Gestión de inventario alimenticio</li>
                         <li>Creación y guardado de recetas</li>
                         <li>Planificación de menús</li>
                         <li>Alertas de productos próximos a vencer</li>
                    </ul>
               </section>

               <section className="recipes">
                    <h2>Recetas Destacadas</h2>
                    <p>Explora algunas de nuestras recetas más populares y empieza a cocinar hoy mismo.</p>
                    <div className="recipe-cards">
                         <div className="recipe-card">
                              <img src={alfredo} alt="Pasta alfredo con champiñones" />
                              <h3>Receta 1</h3>
                              <p>Plato de pasta cremosa con salsa Alfredo y champiñones salteados.</p>
                         </div>
                         <div className="recipe-card">
                              <img src={tortilla} alt="Tortilla Española" />
                              <h3>Receta 2</h3>
                              <p>Clásica tortilla española hecha con papas, cebolla y huevos.</p>
                         </div>
                    </div>
               </section>
          </div>
     );
};

export default Home;
