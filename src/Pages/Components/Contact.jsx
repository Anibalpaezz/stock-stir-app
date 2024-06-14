import React from 'react';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';

import '../../Styles/Contact.css';
import '../../Styles/Global.css';

//Coordenadas del centro del mapa
const center = [-3.745, -38.523];

const Contact = () => {
     return (
          <div className="contact">
               <h1>Contáctanos</h1>
               <div className="contact-info">
                    <p><strong>Teléfono:</strong> +123 456 7890</p>
                    <p><strong>Fax:</strong> +123 456 7891</p>
                    <p><strong>Email:</strong> contacto@ejemplo.com</p>
               </div>
               <div className="map-container">
                    <MapContainer center={center} zoom={10} style={{ height: '400px', width: '100%' }}>
                         <TileLayer
                              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
                              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                         />
                         <Marker position={center}>
                              <Popup>
                                   Ubicación de la empresa
                              </Popup>
                         </Marker>
                    </MapContainer>
               </div>
          </div>
     );
};

export default Contact;
