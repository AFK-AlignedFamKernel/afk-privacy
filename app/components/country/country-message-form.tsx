import React, { useMemo, useState } from "react";
import dynamic from "next/dynamic";
import { useLocalStorage } from "@uidotdev/usehooks";
import IonIcon from "@reacticons/ionicons";
import { LocalStorageKeys, Message, SignedMessageWithProof, PassportRegistration } from "../../lib/types";
import { getEphemeralPubkey } from "../../lib/ephemeral-key";
import { generateNameFromPubkey } from "../../lib/utils";
import { Providers } from "../../lib/providers";
import { postMessageCountry } from "@/lib/country";
import Dialog from "../dialog";
import COUNTRY_DATA from "@/assets/country";
import ZkIdentityComponent from "../zkdid/zk-identity";
import Link from "next/link";
import { useAppStore } from "@/store/app";
// import SignInWithMicrosoftButton from "./siwm";

type MessageFormProps = {
  isInternal?: boolean;
  onSubmit: (message: SignedMessageWithProof) => void;
  connectedKyc?: PassportRegistration;
  isRegisteredProps?: boolean;
};

const prompts = (companyName: string, nationality: string) => [
  // `What’s the tea at ${COUNTRY_DATA[companyName]?.name ?? companyName} ${COUNTRY_DATA[nationality]?.flag}?`,
  `What's can we improve in ${COUNTRY_DATA[companyName]?.name ?? companyName} ${COUNTRY_DATA[nationality]?.flag}?`,
  `What's going unsaid at ${COUNTRY_DATA[companyName]?.name ?? companyName} ${COUNTRY_DATA[nationality]?.flag}?`,
  `What's happening behind the scenes at ${COUNTRY_DATA[companyName]?.name ?? companyName} ${COUNTRY_DATA[nationality]?.flag}?`,
  `What would you say if you weren't being watched? ${COUNTRY_DATA[nationality]?.flag}`,
  `What's the thing nobody's admitting at ${COUNTRY_DATA[companyName]?.name ?? companyName} ${COUNTRY_DATA[nationality]?.flag}?`,
];
const randomPromptIndex = Math.floor(Math.random() * prompts("", "your Nationality").length);

const CountryMessageForm: React.FC<MessageFormProps> = ({ isInternal, onSubmit, connectedKyc, isRegisteredProps }) => {

  const { isRegistered: isRegisteredAppStore } = useAppStore();
  const [currentKYCProvider, setCurrentKYCProvider] = useLocalStorage<string | null>(
    "currentKYCProvider",
    null
  );
  // const [connectedKyc, setConnectedKyc] = useState<PassportRegistration | null>(null);
  const [usedPubkeySelfXyz, setUsedPubkeySelfXyz] = useLocalStorage<string | null>(
    "usedPubkeySelfXyz",
    null
  );
  const [currentKycUUID, setCurrentKycUUID] = useLocalStorage<string | null>(
    "currentKycUUID",
    null
  );
  const [currentProvider, setCurrentProvider] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentKYCProvider,
    null
  );

  const provider = currentProvider ? Providers[currentProvider] : null;
  // const isRegistered = !!connectedKyc;
  const isRegistered = useMemo(() => {
    if (isRegisteredAppStore) {
      return true;
    }
    if (isRegisteredProps) {
      return true;
    }
    if (connectedKyc && connectedKyc?.is_verified && connectedKyc?.nationality) {
      return true;
    }
    return false;
  }, [connectedKyc, isRegisteredProps, isRegisteredAppStore]);
  console.log("isRegistered", isRegistered);

  const senderName = isInternal
    ? generateNameFromPubkey(getEphemeralPubkey()?.toString() ?? "")
    : `Someone from ${COUNTRY_DATA[connectedKyc?.nationality ?? "UHOH"]?.name} ${COUNTRY_DATA[connectedKyc?.nationality ?? "your Nationality"]?.flag}`;
  // : `Someone from ${connectedKyc?.nationality} ${COUNTRY_DATA[connectedKyc?.nationality ?? "UHOH"].name} ${COUNTRY_DATA[connectedKyc?.nationality ?? "your Nationality"]?.flag}`;

  const welcomeMessage = `
    Sign in with passport to anonymously post as "Someone from KYC (country, gender, age)".
  `;

  // State
  const [message, setMessage] = useState("");
  const [isPosting, setIsPosting] = useState(false);
  const [isRegistering, setIsRegistering] = useState("");
  const [status, setStatus] = useState(!isRegistered ? welcomeMessage : "");

  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const handleOpenDialog = () => {
    setIsDialogOpen(!isDialogOpen);
  }
  // Handlers
  async function handleSignIn(providerName: string) {
    try {
      setIsRegistering(providerName);
      // setStatus(`Generating cryptographic proof of your membership without revealing your identity.
      //   This will take about 20 seconds...`);

      // const { anonGroup } = await generateKeyPairAndRegister(providerName);

      // setCurrentGroupId(anonGroup.id);
      // setCurrentProvider(providerName);
      setStatus("");
    } catch (error) {
      console.error("Error:", error);
      setStatus(`Error: ${(error as Error).message}`);
    } finally {
      setIsRegistering("");
    }
  }

  async function resetIdentity() {
    setCurrentProvider(null);
    setStatus(welcomeMessage);
  }

  async function onSubmitMessage(e: React.FormEvent) {
    e.preventDefault();
    if (!message.trim()) return;

    setIsPosting(true);

    try {
      const pubkey = getEphemeralPubkey()?.toString() ?? "";
      const messageObj: Message = {
        // id: crypto.randomUUID().split("-").slice(0, 2).join(""),
        id: crypto.randomUUID(),
        timestamp: new Date(),
        text: message,
        internal: !!isInternal,
        likes: 0,
        anonGroupId: "self-xyz", // TODO: change to provider zkdid
        anonGroupProvider: "self-xyz", // TODO: change to provider zkdid
      };

      const signedMessage = await postMessageCountry(messageObj);

      setMessage("");
      onSubmit(signedMessage as SignedMessageWithProof);
    } catch (err) {
      console.error(err);
      setStatus(`Error: ${(err as Error).message}`);
    } finally {
      setIsPosting(false);
    }
  }

  const isTextAreaDisabled = !!isRegistering || isPosting || !isRegistered;

  const randomPrompt = prompts(connectedKyc?.nationality ?? "FRA", connectedKyc?.nationality ?? "FRA")[randomPromptIndex]

  return (
    <div className="message-form">
      <div style={{ position: "relative" }}>
        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          // placeholder={isRegistered ? randomPrompt : "Sign in with passport to anonymously post as 'Someone from KYC (country, gender, age)'"}
          placeholder={randomPrompt}
          maxLength={280}
          disabled={isTextAreaDisabled}
        />
        {!isTextAreaDisabled && message.length > 0 && (
          <span className="message-form-character-count">
            {message.length}/280
          </span>
        )}
      </div>

      <div className="message-form-footer">
        <div style={{ display: "flex", alignItems: "center" }}>
          <span className="message-form-footer-message">
            {status ? status : `Posting as "${senderName}"`}
          </span>

          {isRegistered && (
            <div className="message-form-footer-buttons">
              <button
                title={
                  "Multiple messages sent by one identity can be linked." +
                  " Refresh your identity by generating a new proof."
                }
                onClick={() => handleSignIn("self-xyz")}
                tabIndex={-1}
              >
                {isRegistering ? (
                  <span className="spinner-icon" />
                ) : (
                  <span className="message-form-refresh-icon">⟳</span>
                )}
              </button>
              <button
                title={
                  "Delete your identity and start over."
                }
                onClick={() => resetIdentity()}
                tabIndex={-1}
              >
                <span className="message-form-reset-icon"><IonIcon name="close-outline" /></span>
              </button>
            </div>
          )}
        </div>

        {isRegistered && (
          <>
            <button
              className="message-form-post-button"
              onClick={onSubmitMessage}
              disabled={!!isRegistering || isPosting || message.length === 0}
            >
              {isPosting ? <span className="spinner-icon small" /> : "Post"}
            </button>
          </>
        )}

        {!isRegistered && (

          <>

            <Link href="/zk-passport">Sign in with passport</Link>
            {/* <button
              onClick={() => handleOpenDialog()}
              disabled={!!isRegistering}
              style={{ marginTop: "10px", borderRadius: "10px", border: "1px solid #000", padding: "5px" }}
            >
              <IonIcon name="person-outline" />
              {isRegistering ? <span className="spinner-icon small" /> : "Sign in with passport"}
            </button>
            {isDialogOpen && (
              <div className="message-form-dialog">
                <button onClick={handleOpenDialog}>Close</button>
                <Dialog title="Sign in with passport" onClose={handleOpenDialog}>
                  <ZkIdentityComponent />
                </Dialog>
              </div>
            )} */}
          </>



        )}
      </div>
    </div>
  );
};

export default dynamic(() => Promise.resolve(CountryMessageForm), {
  ssr: false,
});
