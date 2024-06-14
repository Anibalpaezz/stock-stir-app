import React from 'react';
import { BrowserRouter as Router, Route, Routes, Navigate } from 'react-router-dom';

import './Styles/App.css';
import './Styles/Global.css';

import ProductList from './Pages/ProductList';
import RecipeList from './Pages/RecipeList';
import MenuList from './Pages/MenuList';
import Home from './Pages/Home';
import NavBar from './Pages/Components/NavBar';
import Footer from './Pages/Components/Footer';
import Contact from './Pages/Components/Contact';
import Login from './Pages/Components/Login';

import { AuthProvider } from './Contexts/AuthContext';
import PrivateRoute from './Pages/Components/PrivateRoutes';

import CreateRecipe from './Pages/Components/CreateRecipe';
import CreateMenu from './Pages/Components/CreateMenu';


function App() {
     return (
          <AuthProvider>
               <Router>
                    <div className="app-container">
                         <header className="app-header">
                              <h1>Stock & Stir</h1>
                         </header>
                         <NavBar />
                         <Routes>
                              <Route path="/login" element={<Login />} />
                              <Route
                                   path="/"
                                   element={
                                        <PrivateRoute>
                                             <Home />
                                        </PrivateRoute>
                                   }
                              />
                              <Route
                                   path="/productos"
                                   element={
                                        <PrivateRoute>
                                             <ProductList />
                                        </PrivateRoute>
                                   }
                              />
                              <Route
                                   path="/recetas"
                                   element={
                                        <PrivateRoute>
                                             <RecipeList />
                                        </PrivateRoute>
                                   }
                              />
                              <Route
                                   path="/menus"
                                   element={
                                        <PrivateRoute>
                                             <MenuList />
                                        </PrivateRoute>
                                   }
                              />
                              <Route
                                   path="/crear-receta"
                                   element={
                                        <PrivateRoute>
                                             <CreateRecipe />
                                        </PrivateRoute>
                                   }
                              />
                              <Route
                                   path="/crear-menu"
                                   element={
                                        <PrivateRoute>
                                             <CreateMenu />
                                        </PrivateRoute>
                                   }
                              />
                              <Route path="/contact" element={<Contact />} />
                              <Route path="*" element={<Navigate to="/" />} />
                         </Routes>
                         <Footer />
                    </div>
               </Router>
          </AuthProvider>
     );
}

export default App;
