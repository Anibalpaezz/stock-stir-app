import React, { createContext, useContext, useState, useEffect } from "react";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
     const [user, setUser] = useState(null);
     const [loading, setLoading] = useState(true);

     useEffect(() => {
          const sessionUser = JSON.parse(localStorage.getItem('user'));
          if (sessionUser) {
               setUser(sessionUser);
          }
          setLoading(false);
     }, []);

     const login = (userData) => {
          setUser(userData);
          localStorage.setItem('user', JSON.stringify(userData));
     };

     const logout = () => {
          setUser(null);
          localStorage.removeItem('user');
     };

     return (
          <AuthContext.Provider value={{ user, login, logout, loading }}>
               {children}
          </AuthContext.Provider>
     );
};

export const useAuth = () => useContext(AuthContext);