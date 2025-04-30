import { LocalStorageKeys } from '@/lib/types';
import IonIcon from '@reacticons/ionicons';
import { useLocalStorage } from '@uidotdev/usehooks';
import { useState } from 'react';

export const WelcomeModal = () => {
  const [hasSeenWelcome, setHasSeenWelcome] = useLocalStorage(LocalStorageKeys.HasSeenWelcomeMessage, false);
  const [isOpen, setIsOpen] = useState(!hasSeenWelcome);

  const handleClose = () => {
    setHasSeenWelcome(true);
    setIsOpen(false);
  };

  if (!isOpen) return null;

  return (
    <div className="modal-overlay">
      <div className="modal">
        <button className="modal-close-button" onClick={handleClose}>
          <IonIcon name="close" />
        </button>
        <h2 className="modal-title">Welcome to AFK!</h2>
        <div className="modal-content">
          <p>
            AFK is a platform that allows you to post messages anonymously while proving your identity attributes - all without revealing who you are.
          </p>

          <p>
            Here&apos;s what makes AFK unique:
          </p>

          <ul>
            <li>
              <strong>Organization Verification:</strong> Prove you belong to an organization without revealing your identity
            </li>
            <li>
              <strong>Country Verification:</strong> Show you&apos;re from a specific country while maintaining anonymity
            </li>
            <li>
              <strong>Demographic Verification:</strong> Verify your age/gender without exposing personal details
            </li>
            <li>
              <strong>Status Verification:</strong> Prove you&apos;re a student, government employee, or organization member anonymously
            </li>
          </ul>

          <p>
            We use advanced{' '}
            <a
              href="https://en.wikipedia.org/wiki/Zero-knowledge_proof"
              target="_blank"
              rel="noopener noreferrer"
            >
              Zero Knowledge Proofs
            </a>
            {' '}technology to ensure your privacy. This means you can verify your credentials while keeping your actual identity completely private.
          </p>

          <p>
            Your messages are secure and cannot be linked back to you (except in rare edge cases). Learn more about how it works{' '}
            <a href="https://saleel.xyz/blog/stealthnote/" target="_blank" rel="noopener noreferrer">
              here
            </a>.
          </p>
          <p>Start your journey to anonymity</p>

          <button className="close-button" onClick={handleClose}>
            <IonIcon name="open" />
            LFG
          </button>
        </div>

        <div className="modal-footer">


          <div className="button-container"
          // style={{ display: 'flex', flexDirection: 'row', gap: '10px', alignItems: "baseline", alignSelf: "baseline", justifyContent: 'baseline' }}
          >
            <p className="button" onClick={handleClose}>Ready to start? Click me</p>

            <button className="button" onClick={handleClose}>
              <IonIcon name="open" />
              LFG
            </button>
          </div>
        </div>

      </div>
    </div>
  );
}; 