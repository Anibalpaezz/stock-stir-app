import React, { useState } from "react";
import { supabase } from '../../Supabase/supabaseClient';
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../Contexts/AuthContext";

const Login = () => {
     const [email, setEmail] = useState('');
     const [password, setPassword] = useState('');
     const [error, setError] = useState('');
     const navigate = useNavigate();
     const { login } = useAuth(); // Aquí usamos el contexto

     const handleLogin = async (e) => {
          e.preventDefault();
          setError('');

          try {
               const { data, error } = await supabase
                    .from('usuarios')
                    .select('usuario_id, correo, rol, contraseña')
                    .eq('correo', email)
                    .single();

               if (error || !data) {
                    throw new Error('Correo o contraseña incorrectos.');
               }

               if (data.contraseña !== password) {
                    throw new Error('Correo o contraseña incorrectos.');
               }

               login(data);
               navigate('/');
          } catch (error) {
               console.error('Error durante el inicio de sesión:', error);
               setError(error.message);
          }
     };

     return (
          <div>
               <h2>Login</h2>
               <form onSubmit={handleLogin}>
                    <input
                         type="text"
                         placeholder="Email"
                         value={email}
                         onChange={(e) => setEmail(e.target.value)}
                         required
                    />
                    <input
                         type="password"
                         placeholder="Password"
                         value={password}
                         onChange={(e) => setPassword(e.target.value)}
                         required
                    />
                    <button type="submit">Login</button>
               </form>
               {error && <p>{error}</p>}
          </div>
     );
};

export default Login;