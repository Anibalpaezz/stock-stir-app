import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

import './Styles/App.css';
import ProductList from './Pages/ProductList';
import RecipeList from './Pages/RecipeList';
import Home from './Pages/Home';
import NavBar from './Pages/Components/NavBar';
import Login from './Pages/Components/Login';
import { AuthProvider } from './Contexts/AuthContext';
import PrivateRoute from './Pages/Components/PrivateRoutes';

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
                         </Routes>
                    </div>
               </Router>
          </AuthProvider>
     );
}

export default App;
