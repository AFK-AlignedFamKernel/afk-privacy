import React from 'react';
import Head from 'next/head';
import Link from 'next/link';
import IonIcon from '@reacticons/ionicons';

export default function AboutPage() {
    return (
        <>
            <Head>
                <title>About - AFK</title>
            </Head>
            <div className="modal">

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
                    <p>zk Identity for community country and age verification</p>
                    <p>Start your journey to anonymity</p>

                </div>

                <div className="modal-footer">
                    <p
                        style={{
                            fontSize: '15px',
                            textAlign: 'center',
                            marginBottom: '10px',
                        }}
                    >Big up and thank you</p>

                    <p>
                        Thank to Saleel work with Stealthnote <a href="https://github.com/saleel/stealthnote" target="_blank" rel="noopener noreferrer">Stealthnote</a> for the inspiration
                    </p>
                    <p>Using Noir Lang for the zk proof : <a href="https://github.com/noir-lang/noir" target="_blank" rel="noopener noreferrer">Noir Lang</a></p>
                    <p>
                        Using zkEmail and Noir JWT <a href="https://x.com/zkemail" target="_blank" rel="noopener noreferrer">zkEmail </a>
                        and <a href="https://github.com/zkemail/noir-jwt" target="_blank" rel="noopener noreferrer"> Noir JWT </a>
                        for the inspiration
                    </p>
                </div>

            </div>
        </>
    );
} 