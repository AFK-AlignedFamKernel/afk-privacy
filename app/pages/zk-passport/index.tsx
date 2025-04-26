import { useRef, useState, useEffect } from "react";
import QRCode from "react-qr-code"; // For QR code generation
import type { ZKPassport } from "@zkpassport/sdk";
import ZkPassportRegistration from "@/components/zkdid/zk-passport";

function RegistrationForm() {
 

  return (
    <div className="registration-form">
      <h2>Create an Account</h2>

      <ZkPassportRegistration></ZkPassportRegistration>
    </div>
  );
}

export default RegistrationForm;