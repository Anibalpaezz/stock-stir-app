import React from "react";
import { Link } from "react-router-dom";
import '../../Styles/NavBar.css';
import logo from "../../Photos/Logo - SS - ampliado.jpg";
import defaultProfile from "../../Photos/logo - usuario.png";
import { useAuth } from "../../Contexts/AuthContext";

const NavBar = () => {
     const { user, logout } = useAuth();

     return (
          <nav className="navbar">
               <div className="navbar-left">
                    <Link to="/">
                         <img src={logo} alt="Logo" className="navbar-logo" />
                    </Link>
               </div>
               <div className="navbar-center">
                    <ul className="navbar-links">
                         <Link to="/"><button><li>Inicio</li></button></Link>
                         <Link to="/productos"><button><li>Productos</li></button></Link>
                         <Link to="/recetas"><button><li>Recetas</li></button></Link>
                    </ul>
               </div>
               <div className="navbar-right">
                    {user ? (
                         <>
                              <span>{user.correo}</span>
                              <button onClick={logout}>Logout</button>
                         </>
                    ) : (
                         <Link to="/login">
                              <img src={defaultProfile} alt="Perfil" className="navbar-profile" />
                         </Link>
                    )}
               </div>
          </nav>
     );
};

export default NavBar;