"use client";

import React, { useMemo } from "react";
import Link from "next/link";
import Image from "next/image";
import dynamic from "next/dynamic";
import { useLocalStorage } from "@uidotdev/usehooks";
import IonIcon from "@reacticons/ionicons";
import { LocalStorageKeys, Message } from "../lib/types";
import { Providers } from "../lib/providers";
import { WelcomeModal } from './welcome-modal';
import Loading from './small/loading';
import { usePathname } from 'next/navigation';
import logo from "@/assets/logo192.png";
import logoAfk from "@/assets/afk_logo_circle.png";
// import logo from "@/assets/logo.png";
import CryptoLoading from "./small/crypto-loading";
import COUNTRY_DATA from "@/assets/country";
import { getMyDataMessageCountry } from "@/lib/profile";
import { useAppStore } from "@/store/app";
const Layout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [isDark, setIsDark] = useLocalStorage<boolean>(
    LocalStorageKeys.DarkMode,
    false
  );
  const [currentGroupId] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentGroupId,
    null
  );
  const [currentCountryId, setCurrentCountryId] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentCountryId,
    null
  );
  const [currentProvider] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentProvider,
    null
  );
  const [isSidebarOpen, setIsSidebarOpen] = React.useState(false);
  const [consoleShown, setConsoleShown] = React.useState(false);
  const [isLoading, setIsLoading] = React.useState(false);
  const [isOpenInternal, setIsOpenInternal] = React.useState(false);

  const [isVerified, setIsVerified] = React.useState(false);
  const [isInternal, setIsInternal] = React.useState(false);
  const { isFetchedDataInitialized, setIsFetchedDataInitialized } = useAppStore();
  const emojisList = [
    "👥",
    "🤐",
    "🪪",
    "🕵️‍♂️",
    "🧑‍💻",
    "🔒",
    "🔑",
    "🌐",
    "👻",
    "👁️‍🗨️",
    "👤"
  ]

  const getRandomEmojis = () => {
    const shuffled = [...emojisList].sort(() => Math.random() - 0.5);
    return shuffled.slice(0, 3); // Get first 3 unique emojis after shuffling
  };

  const [randomEmojis] = React.useState(getRandomEmojis());
  const [randomEmojisSidebar] = React.useState(getRandomEmojis());
  const [myData, setMyData] = React.useState<any>(null);

  const isRegistered = useMemo(() => {
    if (myData && myData?.is_verified && myData?.nationality) {
      return true;
    }
    return false;
  }, [myData]);

  const currentKyc = useMemo(() => {
    if (myData && myData?.is_verified && myData?.nationality) {
      return myData;
    }
    return null;
  }, [myData]);

  const [currentGender, setCurrentGender] = useLocalStorage<string | null>(
    LocalStorageKeys.CurrentGender,
    null
  );
  const [isAdult, setIsAdult] = useLocalStorage<boolean | null>(
    LocalStorageKeys.IsAdult,
    null
  );

  const pathname = usePathname();

  let slug = null;
  if (currentProvider && currentGroupId) {
    const provider = Providers[currentProvider];
    slug = provider.getSlug();
  }

  // Set dark mode
  React.useEffect(() => {
    document.documentElement.classList.toggle("dark", isDark);
  }, [isDark]);

  // Handle route changes
  React.useEffect(() => {
    const handleRouteChange = () => {
      setIsLoading(true);
    };

    const handleRouteComplete = () => {
      // Add a small delay to ensure smooth transition
      setTimeout(() => {
        setIsLoading(false);
      }, 300);
    };

    // Listen for route changes
    window.addEventListener('beforeunload', handleRouteChange);
    window.addEventListener('load', handleRouteComplete);

    return () => {
      window.removeEventListener('beforeunload', handleRouteChange);
      window.removeEventListener('load', handleRouteComplete);
    };
  }, []);

  // Also handle pathname changes
  React.useEffect(() => {
    setIsLoading(true);
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 300);
    return () => clearTimeout(timer);
  }, [pathname]);

  React.useEffect(() => {
    if (consoleShown) {
      return;
    }

    console.log(
      '%c📝 If you run in to any errors, please create an issue at https://github.com/AFK-AlignedFamKernel/afk-privacy/issues\n' +
      '🐦 You can also reach out to me on Twitter at https://twitter.com/AFK_AlignedFamK or https://x.com/MSG_Encrypted',
      'background: #efefef; color: black; font-size: 16px; padding: 10px; border-radius: 3px;'
    );
    setConsoleShown(true);
  }, [consoleShown]);



  React.useEffect(() => {
    const fetchMyData = async () => {
      const message = "getMyData";
      const messageObj: Message = {
        // id: crypto.randomUUID().split("-").slice(0, 2).join(""),
        id: crypto.randomUUID(),
        timestamp: new Date(),
        text: message,
        internal: !!isInternal,
        likes: 0,
        anonGroupId: "selfxyz",
        anonGroupProvider: "selfxyz",
      };

      const res = await getMyDataMessageCountry(messageObj);

      const credentialSubject = res?.credentialSubject;
      if (credentialSubject?.is_verified) {
        setIsVerified(true);
      }
      if (credentialSubject) {
        console.log("credentialSubject", credentialSubject);

        if (credentialSubject?.nationality) {
          setCurrentCountryId(credentialSubject?.nationality);
        }
        if (credentialSubject?.gender) {
          setCurrentGender(credentialSubject?.gender);
        }

      }
      setMyData(myData);
      setIsFetchedDataInitialized(true);
    };
    if (!isFetchedDataInitialized) {
      fetchMyData();
    }
  }, [isFetchedDataInitialized]);

  return (
    <>
      <div className="page">
        <div className="mobile-header">
          <div
            className="mobile-header-logo"
            style={isSidebarOpen ? { display: "none" } : { display: "flex", alignItems: "center", gap: "10px" }}
          >

            <Link href="/">

              <div className="mobile-header-logo-text"
              >

                AFK
                {randomEmojis.map((emoji, index) => (
                  <span key={index}>{emoji}</span>
                ))}
              </div>
            </Link>

            {/* <Image src={logo} alt="Bro"
              width={50}
              height={50}
            />
            <Image src={logoAfk} alt="AFK"
              width={50}
              height={50}
            /> */}
          </div>
          <button
            className={`sidebar-toggle ${isSidebarOpen ? "open" : ""}`}
            onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          >
            ☰
          </button>

        </div>
        <aside className={`sidebar ${isSidebarOpen ? "open" : ""}`}>
          <div style={{ display: "flex", alignItems: "center", gap: "10px" }}>
            <div className="logo">
              <p style={{ fontWeight: "bold", fontStyle: "italic", fontFamily: "monospace" }}>AFK
                {randomEmojisSidebar.map((emoji, index) => (
                  <span key={index}>{emoji}</span>
                ))}
              </p>
            </div>

            {/* <div className="logo">

              <Link href="/">
                <Image src={logo} alt="Bro"
                  width={50}
                  height={50}
                />
                <Image src={logoAfk} alt="AFK"
                  width={50}
                  height={50}
                />
              </Link>
            </div> */}
          </div>

          <nav className="sidebar-nav">
            <div className="sidebar-nav-header">
              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="/"
                className="sidebar-nav-item"
              >
                👥 Home
              </Link>

              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="/country"
                className="sidebar-nav-item"
              >
                🤐Country
              </Link>
              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="/poll"
                className="sidebar-nav-item"
              >
                🔏 Poll
              </Link>
              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="/zk-passport"
                className="sidebar-nav-item"
              >
                🪪 zkDID
              </Link>

              <div
                onClick={() => setIsOpenInternal(!isOpenInternal)}
                className="sidebar-nav-item"
              >
                <IonIcon name={isOpenInternal ? "chevron-down-outline" : "chevron-forward-outline"} />

                {isOpenInternal ? "🔒 Close Internal fam" : "🔑 Internal communities"}
              </div>

              {isOpenInternal &&

                <>
                  {/* {slug && (
                    <Link
                      onClick={() => setIsSidebarOpen(false)}
                      href={`/${slug}/${currentGroupId}/internal`}
                      className="sidebar-nav-item"
                    >
                      {currentGroupId} Internal
                    </Link>
                  )} */}

                  {currentGroupId &&
                    <Link
                      onClick={() => setIsSidebarOpen(false)}
                      href={`/${slug}/${currentGroupId}/internal`}
                      className="sidebar-nav-item"
                    >
                      {currentGroupId} Internal
                    </Link>
                  }


                  {currentCountryId && (
                    <Link
                      onClick={() => setIsSidebarOpen(false)}
                      href={`/country/${currentCountryId}/internal`}
                      className="sidebar-nav-item"
                    >
                      {currentCountryId} Country {COUNTRY_DATA[currentCountryId].name} {COUNTRY_DATA[currentCountryId].flag}
                    </Link>
                  )}

                </>}

            </div>


            <div className="sidebar-nav-footer">
              <button
                onClick={() => {
                  setIsDark(!isDark);
                  setIsSidebarOpen(false);
                }}
                className="sidebar-nav-footer-item"
              >
                {isDark ? <IonIcon name="moon" /> : <IonIcon name="sunny" />}

              </button>
              {/* <Link
                onClick={() => setIsSidebarOpen(false)}
                href="https://saleel.xyz/blog/stealthnote/"
                target="_blank"
                rel="noopener noreferrer"
                title="How it works"
                className="sidebar-nav-footer-item"
              >
                <IonIcon name="reader" />
              </Link> */}
              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="/about"
                // target="_blank"
                title="About AFK"
                className="sidebar-nav-footer-item"
              >
                <IonIcon name="reader" />
              </Link>
              <Link
                onClick={() => setIsSidebarOpen(false)}
                className="sidebar-nav-footer-item"
                target="_blank"
                title="Source Code"
                rel="noopener noreferrer"
                href="https://github.com/AFK-AlignedFamKernel/afk-privacy"
              >
                <IonIcon name="logo-github" />
              </Link>
              <Link
                onClick={() => setIsSidebarOpen(false)}
                href="https://x.com/AFK_AlignedFamK"
                target="_blank"
                rel="noopener noreferrer"
                title="Twitter"
                className="sidebar-nav-footer-item"
              >
                <IonIcon name="logo-twitter" />
              </Link>
            </div>
          </nav>

          <p className="sidebar-nav-copyright">
            <span>Made with </span>
            <Link
              href="https://noir-lang.org"
              target="_blank"
              rel="noopener noreferrer"
              style={{ color: '#382E81' }}
            >
              Noir
            </Link>
            <span> ❤️ </span>
          </p>
          <div className="sidebar-nav-footer-links">
            <Link
              href="/disclaimer"
            >
              Disclaimer
            </Link>
            <Link
              href="/privacy"
            >
              Privacy Policy
            </Link>
          </div>
        </aside>
        <main className="container">
          <div className="content">
            {isLoading && <CryptoLoading />}
            {children}</div>
        </main>
      </div>

      <WelcomeModal />
      {isLoading && <Loading />}
    </>
  );
};

const LayoutClient = dynamic(() => Promise.resolve(Layout), {
  ssr: false,
});

export default LayoutClient;
