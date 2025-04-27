import React, { useState } from 'react';
import { useLocalStorage } from "@uidotdev/usehooks";
import IonIcon from "@reacticons/ionicons";
import { LocalStorageKeys, PassportRegistration, SignedMessage } from "../../lib/types";
import Dialog from "../dialog";
import SelfXyzRegistration from "../zkdid/self-xyz";
import { signMessageSelfXyz } from '@/lib/zk-did';

type PollFormProps = {
    onSubmit: (poll: any) => void;
    connectedKyc?: PassportRegistration;
};

const ReviewPollForm: React.FC<PollFormProps> = ({ onSubmit, connectedKyc }) => {
    // State for poll form
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [options, setOptions] = useState<string[]>(['', '']); // Minimum 2 options
    const [isYesNo, setIsYesNo] = useState(false);
    const [selectedCountries, setSelectedCountries] = useState<string[]>([]);
    const [selectedOrganizations, setSelectedOrganizations] = useState<string[]>([]);
    const [multiselect, setMultiselect] = useState(false);
    const [maxOptions, setMaxOptions] = useState(1);
    const [minOptions, setMinOptions] = useState(1);
    const [endDate, setEndDate] = useState("");
    const [showResultsPublicly, setShowResultsPublicly] = useState(true);
    const [isOnlyOrganizations, setIsOnlyOrganizations] = useState(false);
    const [isOnlyKycVerified, setIsOnlyKycVerified] = useState(false);

    const [isPosting, setIsPosting] = useState(false);
    const [error, setError] = useState("");

    // Dialog state for KYC
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const isRegistered = !!connectedKyc;

    const handleAddOption = () => {
        setOptions([...options, '']);
    };

    const handleRemoveOption = (index: number) => {
        if (options.length > 2) {
            const newOptions = [...options];
            newOptions.splice(index, 1);
            setOptions(newOptions);
        }
    };

    const handleOptionChange = (index: number, value: string) => {
        const newOptions = [...options];
        newOptions[index] = value;
        setOptions(newOptions);
    };

    console.log("review-poll-form connectedKyc", connectedKyc);

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        // if (!isRegistered) {
        //     setIsDialogOpen(true);
        //     return;
        // }

        setIsPosting(true);
        setError("");

        try {

            const message = {
                id: crypto.randomUUID(),
                text: title,
                timestamp: new Date(),
                internal: false,
                anonGroupId: 'self-xyz',
                anonGroupProvider: 'self-xyz',
                likes: 0,
                replyCount: 0,
                parentId: null,
            }
            const {signature, ephemeralPubkey, ephemeralPubkeyExpiry} = await signMessageSelfXyz(message);

            const signedMessage: SignedMessage = {
                ...message,
                signature: signature,
                ephemeralPubkey: ephemeralPubkey,
                ephemeralPubkeyExpiry: ephemeralPubkeyExpiry,
              };
            
            console.log("review-poll-form signedMessage", signedMessage);
            const pollData = {
                title,
                description,
                is_yes_no: isYesNo,
                isYesNo: isYesNo, 
                answersOptions:isYesNo ? ['Yes', 'No'] : options.filter(opt => opt.trim()),
                answerOptions:isYesNo ? ['Yes', 'No'] : options.filter(opt => opt.trim()),
                maxOptions: isYesNo ? 2 : maxOptions,
                minOptions: isYesNo ? 2 : minOptions,
                answer_options: isYesNo ? ['Yes', 'No'] : options.filter(opt => opt.trim()),
                multiselect,
                ends_at: new Date(endDate).toISOString(),
                endsAt: new Date(endDate).toISOString(),
                show_results_publicly: showResultsPublicly,
                showResultsPublicly: showResultsPublicly,
                is_only_organizations: isOnlyOrganizations,
                is_only_kyc_verified: isOnlyKycVerified,
                group_id: 'self-xyz',
                group_provider: 'self-xyz',
                selected_countries: [],
                selected_organizations: [],
                is_nationality: false,
                signedMessage: {
                    ...signedMessage,
                    pubkey: signedMessage.ephemeralPubkey.toString(),
                    ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
                    signature: signedMessage.signature.toString(),
                },
                ...signedMessage,
                pubkey: signedMessage.ephemeralPubkey.toString(),
                ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
                signature: signedMessage.signature.toString(),

                // signedMessage: signedMessage.toString(),
            };

            const response = await fetch('/api/poll/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${signedMessage.signature}`,
                },
                body: JSON.stringify({
                    ...pollData,
                    signedMessage: {
                        ...signedMessage,
                        pubkey: signedMessage.ephemeralPubkey.toString(),
                        ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
                        signature: signedMessage.signature.toString(),
                    },
                }),
            });

            if (!response.ok) {
                throw new Error('Failed to create poll');
            }

            const createdPoll = await response.json();
            onSubmit(createdPoll);

            // Reset form
            setTitle("");
            setDescription("");
            setOptions(['', '']);
            setIsYesNo(false);
            setMultiselect(false);
            setMaxOptions(1);
            setMinOptions(1);
            setEndDate("");
            setShowResultsPublicly(true);
            setIsOnlyOrganizations(false);
            setIsOnlyKycVerified(false);
        } catch (err) {
            console.error("review-poll-form error", err);
            setError((err as Error).message);
        } finally {
            setIsPosting(false);
        }
    };

    return (
        <div className="poll-form">
            <form onSubmit={handleSubmit}>
                <div className="form-group">
                    <label htmlFor="title">Poll Title *</label>
                    <input
                        id="title"
                        type="text"
                        value={title}
                        onChange={(e) => setTitle(e.target.value)}
                        required
                        maxLength={200}
                        placeholder="What would you like to ask?"
                    />
                </div>

                <div className="form-group">
                    <label htmlFor="description">Description</label>
                    <textarea
                        id="description"
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        maxLength={1000}
                        placeholder="Add more context to your question (optional)"
                    />
                </div>

                <div className="form-group">
                    <label>
                        <input
                            type="checkbox"
                            checked={isYesNo}
                            onChange={(e) => setIsYesNo(e.target.checked)}
                        />
                        Yes/No Question
                    </label>
                </div>

                {!isYesNo && (
                    <div className="form-group">
                        <label>Options *</label>
                        {options.map((option, index) => (
                            <div key={index} className="option-input">
                                <input
                                    type="text"
                                    value={option}
                                    onChange={(e) => handleOptionChange(index, e.target.value)}
                                    placeholder={`Option ${index + 1}`}
                                    required
                                />
                                {options.length > 2 && (
                                    <button
                                        type="button"
                                        onClick={() => handleRemoveOption(index)}
                                        className="remove-option"
                                    >
                                        <IonIcon name="close-outline" />
                                    </button>
                                )}
                            </div>
                        ))}
                        <button
                            type="button"
                            onClick={handleAddOption}
                            className="add-option"
                        >
                            Add Option
                        </button>
                    </div>
                )}

                <div className="form-group">
                    <label>
                        <input
                            type="checkbox"
                            checked={multiselect}
                            onChange={(e) => setMultiselect(e.target.checked)}
                        />
                        Allow Multiple Selections
                    </label>
                </div>

                {multiselect && (
                    <>
                        <div className="form-group">
                            <label htmlFor="minOptions">Minimum Selections</label>
                            <input
                                id="minOptions"
                                type="number"
                                min={1}
                                max={options.length}
                                value={minOptions}
                                onChange={(e) => setMinOptions(Number(e.target.value))}
                            />
                        </div>
                        <div className="form-group">
                            <label htmlFor="maxOptions">Maximum Selections</label>
                            <input
                                id="maxOptions"
                                type="number"
                                min={minOptions}
                                max={options.length}
                                value={maxOptions}
                                onChange={(e) => setMaxOptions(Number(e.target.value))}
                            />
                        </div>
                    </>
                )}

                <div className="form-group">
                    <label htmlFor="endDate">End Date *</label>
                    <input
                        id="endDate"
                        type="datetime-local"
                        value={endDate}
                        onChange={(e) => setEndDate(e.target.value)}
                        required
                        min={new Date().toISOString().slice(0, 16)}
                    />
                </div>

                <div className="form-group">
                    <label>
                        <input
                            type="checkbox"
                            checked={showResultsPublicly}
                            onChange={(e) => setShowResultsPublicly(e.target.checked)}
                        />
                        Show Results Publicly
                    </label>
                </div>

                <div className="form-group">
                    <label>Who can vote?</label>
                    <div>
                        <label>
                            <input
                                type="checkbox"
                                checked={isOnlyOrganizations}
                                onChange={(e) => setIsOnlyOrganizations(e.target.checked)}
                            />
                            Only Organizations
                        </label>
                    </div>
                    <div>
                        <label>
                            <input
                                type="checkbox"
                                checked={isOnlyKycVerified}
                                onChange={(e) => setIsOnlyKycVerified(e.target.checked)}
                            />
                            Only KYC Verified Users
                        </label>
                    </div>
                </div>

                {error && <div className="error-message">{error}</div>}

                <button
                    type="submit"
                    disabled={isPosting}
                    className="submit-button"
                >
                    {isPosting ? "Creating Poll..." : "Create Poll"}
                </button>
            </form>

            {isDialogOpen && !isRegistered && (
                <Dialog title="Sign in with passport" onClose={() => setIsDialogOpen(false)}>
                    <SelfXyzRegistration />
                </Dialog>
            )}
        </div>
    );
};

export default ReviewPollForm;
