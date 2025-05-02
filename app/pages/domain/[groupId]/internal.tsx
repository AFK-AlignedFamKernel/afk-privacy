"use client";

import React, { useState } from "react";
import Head from "next/head";
import Image from "next/image";
import { useRouter } from "next/router";
import { useLocalStorage } from "@uidotdev/usehooks";
import MessageList from "../../../components/message-list";
import { ProviderSlugKeyMap } from "../../../lib/providers";
import InternalReviewList from "@/components/review/internal-review-list";
// See messages from one anon group
export default function GroupPage() {
  const groupId = useRouter().query.groupId as string;
  const slug = useRouter().query.slug as string;

  const [activeTab, setActiveTab] = useState('messages');

  const [currentGroupId] = useLocalStorage<string | null>(
    "currentGroupId",
    null
  );


  const provider = ProviderSlugKeyMap[slug ?? "domain"];
  const anonGroup = provider.getAnonGroup(groupId);

  const tabs = [
    { id: 'messages', label: 'Messages' },
    { id: 'polls', label: 'Polls' }
  ];
  if (!groupId) {
    return <>
      <div>
        <h1>No group id</h1>
      </div>
    </>;
  }


  const renderDescriptionMessages = () => {
    if (activeTab === "messages") {
      return (
        <div className="company-description">
          Messages sent here are hidden from the public board, and only visible to members of {anonGroup.title}
          . Server hosting these messages can still see them.
        </div>)
    } else {
      return (
        <div className="company-description">
          Polls are hidden from the public board, and only visible to members of {anonGroup.title}.
          Server hosting these messages can still see them.

        </div>
      )
    }
  }

  return (
    <>
      <Head>
        <title>{groupId} Internal message board from {anonGroup.title} - AFK</title>
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

      <div className="company-info">
        <div style={{ display: "flex", flexDirection: "row", alignItems: "center", marginBottom: "1rem" }}>
          <div className="company-logo">
            <Image
              src={anonGroup.logoUrl}
              alt={anonGroup.title}
              width={50}
              height={50}
            />
          </div>
          <div>
            <div className="company-title">{anonGroup.title} Internal Board</div>
          </div>

        </div>

        <div className="company-description" style={{ marginBottom: "1rem" }}>
          {renderDescriptionMessages()}
        </div>
      </div>

      {activeTab === "messages" && (
        <>
          <div className="domain-page">


            <MessageList
              groupId={groupId}
              showMessageForm={currentGroupId == groupId}
              isInternal={true}
            />
          </div>
        </  >
      )}

      {activeTab === "polls" && (
        <div>
          <p style={{ fontSize: "1rem", fontWeight: "bold", fontStyle: "italic" }}>Polls of {anonGroup.title}</p>
          <InternalReviewList
            groupId={groupId}
            showMessageForm={currentGroupId == groupId}
            isInternal={false}
          />
        </div>
      )}

    </>
  );
}
