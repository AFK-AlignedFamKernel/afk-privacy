"use client";

import React, { useState } from "react";
import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/router";
import { useLocalStorage } from "@uidotdev/usehooks";
import MessageList from "../../../components/message-list";
import { ProviderSlugKeyMap } from "../../../lib/providers";
import MessageListCountry from "@/components/country/coutry-message-list";
import COUNTRY_DATA from "@/assets/country";
import ReviewList from "@/components/review/review-list";
import InternalReviewList from "@/components/review/internal-review-list";

// See messages from one anon group
export default function NationalityPageInternal() {
  const [currentGroupId] = useLocalStorage<string | null>(
    "currentGroupId",
    null
  );
  const [activeTab, setActiveTab] = useState('messages');


  const nationality = useRouter().query.nationality as string;
  console.log("nationality", nationality);

  if (!nationality) {
    return null;
  }

  const tabs = [
    { id: 'messages', label: 'Messages' },
    { id: 'polls', label: 'Polls' }
  ];


  const renderDescriptionMessages = () => {
    if (activeTab === "messages") {
      return (
        <div className="company-description">
          Messages sent here are hidden from the public board, and only visible to members of {COUNTRY_DATA[nationality]?.name} {COUNTRY_DATA[nationality]?.flag}.
          Server hosting these messages can still see them.
        </div>)
    } else {
      return (
        <div className="company-description">
          Polls are hidden from the public board, and only visible to members of {COUNTRY_DATA[nationality]?.name} {COUNTRY_DATA[nationality]?.flag}.
          Server hosting these messages can still see them.

        </div>
      )
    }
  }


  return (
    <>
      <Head>
        <title>{nationality} Anonymous messages from members of {nationality} - AFK</title>
      </Head>




      <div className="domain-page">
        <div className="company-info">
          <div className="company-logo">
            {COUNTRY_DATA[nationality]?.flag}

          </div>
          <div>
            <div className="company-title">{COUNTRY_DATA[nationality]?.name}</div>
            <div className="company-description">
              Anonymous messages from members of {COUNTRY_DATA[nationality]?.name}
            </div>
          </div>
        </div>


      </div>
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

      {renderDescriptionMessages()}

      {activeTab === "messages" && (
        <MessageListCountry
          groupId={nationality}
          showMessageForm={true}
          isInternal={true}
        />
      )}

      {activeTab === "polls" && (
        <div>
          <h1>Polls</h1>
          <InternalReviewList
            // groupId={nationality}
            country={nationality}
            showMessageForm={true}
            isInternal={true}
          />
        </div>
      )}
    </>
  );
}
