import React from "react";
import { Link } from 'react-router-dom';

import "../../Styles/Footer.css";
import '../../Styles/Global.css';

import { FaFacebook, FaTwitter, FaInstagram, FaLinkedin } from 'react-icons/fa';

const Footer = () => {
     return (
          <footer className="footer">
               <div className="footer-content">
                    <div className="footer-links">
                         <Link to="/">Inicio</Link>
                         <Link to="/about">Sobre nosotros</Link>
                         <Link to="/contact">Contacto</Link>
                    </div>
                    <div className="footer-info">
                         <p>Dirección: Calle del Gobernador 103, Aranjuez, España</p>
                         <p>Email: administracion@stock.stir.com</p>
                         <div className="footer-social">
                              <a href="https://facebook.com" target="_blank" rel="noopener noreferrer"><FaFacebook /></a>
                              <a href="https://twitter.com" target="_blank" rel="noopener noreferrer"><FaTwitter /></a>
                              <a href="https://instagram.com" target="_blank" rel="noopener noreferrer"><FaInstagram /></a>
                              <a href="https://linkedin.com" target="_blank" rel="noopener noreferrer"><FaLinkedin /></a>
                         </div>
                    </div>
                    <div className="footer-rights">
                         <p>&copy; 2024 Stock & Stir. Todos los derechos reservados.</p>
                    </div>
               </div>
          </footer>
     );
};

export default Footer;
