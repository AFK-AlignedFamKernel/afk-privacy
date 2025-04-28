import React, { useState } from "react";
import Head from "next/head";
import MessageList from "../components/message-list";
import MessageListCountry from "@/components/country/coutry-message-list";
import ReviewList from "@/components/review/review-list";
// import "../styles/tab-selector.scss";

export default function HomePage() {
  const [activeTab, setActiveTab] = useState('organizations');

  const tabs = [
    { id: 'organizations', label: 'Organizations' },
    { id: 'country', label: 'Country' },
    { id: 'polls', label: 'Polls' }
  ];

  return (
    <>
      <Head>
        <title>AFK - Anonymous messages from your coworkers, country and people</title>
        <meta name="description" content="AFK is a platform for anonymous messages from your coworkers, country and people" />
      </Head>

      <div className="tab-selector">
        <div className="tabs">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              className={`tab ${activeTab === tab.id ? 'active' : ''}`}
              onClick={() => setActiveTab(tab.id)}
            >
              {tab.label}
            </button>
          ))}
        </div>
      </div>

      <div className="home-page">
        {activeTab === 'organizations' && <MessageList showMessageForm />}
        {activeTab === 'country' && <MessageListCountry showMessageForm />}
        {activeTab === 'polls' && <ReviewList showMessageForm />}
      </div>
    </>
  );
}
