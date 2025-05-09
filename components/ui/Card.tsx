import React from 'react';

type CardProps = {
  children: React.ReactNode;
  className?: string;
};

const Card: React.FC<CardProps> = ({ children, className = '' }) => {
  return (
    <div className={`p-4 bg-white rounded shadow ${className}`} role="article">
      {children}
    </div>
  );
};

export default Card; 