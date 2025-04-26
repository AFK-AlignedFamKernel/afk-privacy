import React from "react";
import IonIcon from "@reacticons/ionicons";

interface DialogProps {
  title: string;
  onClose: () => void;
  children: React.ReactNode;
}

const Dialog: React.FC<DialogProps> = ({ title, onClose, children }) => {
  return (
    <div className="dialog-overlay">
      <div className="dialog">
        <div className="dialog-header">
          <h3>{title}</h3>
          <button onClick={onClose} className="dialog-close">
            <IonIcon name="close-outline" />
          </button>
        </div>
        <div className="dialog-content">
          {children}
        </div>
      </div>
    </div>
  );
};

export default Dialog;
