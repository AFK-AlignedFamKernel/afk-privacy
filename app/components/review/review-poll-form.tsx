import React, { useEffect, useState } from 'react';
import { useLocalStorage } from "@uidotdev/usehooks";
import IonIcon from "@reacticons/ionicons";
import { LocalStorageKeys, PassportRegistration, SignedMessage } from "../../lib/types";
import Dialog from "../dialog";
import SelfXyzRegistration from "../zkdid/self-xyz";
import { signMessageSelfXyz } from '@/lib/zk-did';
import { domainNames } from "../../lib/constants";
import COUNTRY_DATA from '@/assets/country';
import { useRouter } from 'next/router';
type PollFormProps = {
    onSubmit: (poll: any) => void;
    connectedKyc?: PassportRegistration;
    selectedOrganization?: string[];
    selectedCountriesProps?: string[];
    isInternal?: boolean;
};

const ReviewPollForm: React.FC<PollFormProps> = (props: PollFormProps) => {

    const { connectedKyc, selectedOrganization, selectedCountriesProps, isInternal: isInternalProps } = props;
    const router = useRouter();
    // State for poll form
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [options, setOptions] = useState<string[]>(['', '']); // Minimum 2 options
    const [isYesNo, setIsYesNo] = useState(true);
    const [selectedCountries, setSelectedCountries] = useState<string[]>(selectedCountriesProps || []);
    const [selectedOrganizations, setSelectedOrganizations] = useState<string[]>(selectedOrganization || []);
    const [isInternal, setIsInternal] = useState(isInternalProps || false);

    const [multiselect, setMultiselect] = useState(false);
    const [maxOptions, setMaxOptions] = useState(1);
    const [minOptions, setMinOptions] = useState(1);
    // const [endDate, setEndDate] = useState( new Date().toISOString().slice(0, 16));
    const [endDate, setEndDate] = useState(new Date(new Date().setHours(new Date().getHours() + 72)).toISOString().slice(0, 16));
    const [showResultsPublicly, setShowResultsPublicly] = useState(true);
    const [isOnlyOrganizations, setIsOnlyOrganizations] = useState(selectedOrganizations && selectedOrganizations?.length > 0 ? true : false);
    const [isOnlyKycVerified, setIsOnlyKycVerified] = useState(false);
    const [isSpecificCountries, setIsSpecificCountries] = useState(selectedCountries && selectedCountries?.length > 0 ? true : false);
    const [isDialogOpen, setIsDialogOpen] = useState(false);
    const [isOnlySelfXyz, setIsOnlySelfXyz] = useState(false);
    const isRegistered = !!connectedKyc;

    const [isOrganizationsFetched, setIsOrganizationsFetched] = useState(false);

    const [isPosting, setIsPosting] = useState(false);
    const [error, setError] = useState("");

    const [organizations, setOrganizations] = useState<any[]>([]);

    const handleAddOption = () => {
        setOptions([...options, '']);
    };

    const handleFetchOrganizations = async () => {
        const response = await fetch('/api/messages/fetchOrganizations');
        const data = await response.json();
        console.log("data", data);
        setOrganizations(data);
        return data;
    }

    useEffect(() => {
        if (!isOrganizationsFetched) {
            handleFetchOrganizations();
            setIsOrganizationsFetched(true);
        }
    }, [isOrganizationsFetched]);

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

    const handleCountrySelect = (countryCode: string) => {
        setSelectedCountries(prev => {
            if (prev.includes(countryCode)) {
                return prev.filter(code => code !== countryCode);
            }
            return [...prev, countryCode];
        });
    };

    const handleOrganizationSelect = (domain: string) => {
        setSelectedOrganizations(prev => {
            if (prev.includes(domain)) {
                return prev.filter(d => d !== domain);
            }
            return [...prev, domain];
        });
    };

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
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
            };

            const { signature, ephemeralPubkey, ephemeralPubkeyExpiry } = await signMessageSelfXyz(message);

            if (!signature || !ephemeralPubkey || !ephemeralPubkeyExpiry) {
                throw new Error("Failed to sign message");
            }

            const signedMessage: SignedMessage = {
                ...message,
                signature,
                ephemeralPubkey,
                ephemeralPubkeyExpiry,
            };

            const pollData = {
                title,
                description,
                is_yes_no: isYesNo,
                answer_options: isYesNo ? ['Yes', 'No'] : options.filter(opt => opt.trim()),
                max_options: isYesNo ? 2 : maxOptions,
                min_options: isYesNo ? 2 : minOptions,
                multiselect,
                ends_at: new Date(endDate).toISOString(),
                is_show_results_publicly: showResultsPublicly,
                is_only_organizations: isOnlyOrganizations,
                is_only_kyc_verified: isOnlyKycVerified,
                is_specific_countries: isSpecificCountries,
                selected_organizations: selectedOrganizations,
                selected_countries: selectedCountries,
                is_internal: isInternal,
                signedMessage: {
                    ...signedMessage,
                    pubkey: signedMessage.ephemeralPubkey.toString(),
                    ephemeralPubkey: signedMessage.ephemeralPubkey.toString(),
                    signature: signedMessage.signature.toString(),
                },
            };
            console.log("pollData", pollData);

            const response = await fetch('/api/poll/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ ...pollData, ...pollData?.signedMessage, signedMessage: pollData?.signedMessage }),
            });

            if (!response.ok) {
                throw new Error('Failed to create poll');
            }

            const createdPoll = await response.json();


            // onSubmit(createdPoll);

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
            setIsInternal(false);
            setIsOnlyKycVerified(false);
            setIsSpecificCountries(false);
            setSelectedCountries([]);
            setSelectedOrganizations([]);

            if (createdPoll?.id) {
                router.push(`/poll/${createdPoll?.id}`);
            }

        } catch (err) {
            setIsPosting(false);

            console.error("Error creating poll:", err);
            setError((err as Error)?.message);
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

                <div className="requirement-option">
                    <label>
                        <input
                            type="checkbox"
                            checked={isInternal}
                            onChange={(e) => setIsInternal(e.target.checked)}
                        />
                        Internal Poll
                    </label>
                </div>

                <div className="form-group">
                    <label>Who can vote?</label>
                    <div className="voter-requirements">
                        <div className="requirement-option">
                            <label>
                                <input
                                    type="checkbox"
                                    checked={isOnlyOrganizations}
                                    onChange={(e) => setIsOnlyOrganizations(e.target.checked)}
                                />
                                Organizations requirements
                            </label>
                        </div>
                        <div className="requirement-option">
                            <label>
                                <input
                                    type="checkbox"
                                    checked={isOnlyKycVerified}
                                    onChange={(e) => setIsOnlyKycVerified(e.target.checked)}
                                />
                                KYC Verified Users
                            </label>
                        </div>
                        <div className="requirement-option">
                            <label>
                                <input
                                    type="checkbox"
                                    checked={isSpecificCountries}
                                    onChange={(e) => setIsSpecificCountries(e.target.checked)}
                                />
                                Specific Countries to target
                            </label>
                        </div>
                    </div>
                </div>

                {isOnlyOrganizations && (
                    <div className="form-group">
                        {/* <label>Select Organization Types</label>
                        <div className="organization-selector">
                            {Object.entries(domainNames).map(([domain, description]) => (
                                <div key={domain} className="organization-option">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={selectedOrganizations.includes(domain)}
                                            onChange={() => handleOrganizationSelect(domain)}
                                        />
                                        {description} (.{domain})
                                    </label>
                                </div>
                            ))}
                        </div> */}
                        <p>Select organizations</p>
                        <div className="organization-selector">
                            {organizations.map((organization) => (
                                <div key={organization?.id} className="organization-option">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={selectedOrganizations.includes(organization?.name)}
                                            onChange={() => handleOrganizationSelect(organization?.name)}
                                        />
                                        {organization.name}
                                    </label>
                                </div>
                            ))}
                        </div>

                        {/* <div className="organization-selector">
                            {Object.entries(domainNames).map(([domain, description]) => (
                                <div key={domain} className="organization-option">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={selectedOrganizations.includes(domain)}
                                            onChange={() => handleOrganizationSelect(domain)}
                                        />
                                        {description} (.{domain})
                                    </label>
                                </div>
                            ))}
                        </div> */}
                    </div>
                )}


                {isSpecificCountries && (
                    <div className="form-group">
                        <label>Select Countries</label>
                        <div className="country-selector">
                            {Object.entries(COUNTRY_DATA).map((country) => (
                                <div key={country?.[0]} className="country-option">
                                    <label>
                                        <input
                                            type="checkbox"
                                            checked={selectedCountries.includes(country?.[1]?.isoCode)}
                                            onChange={() => handleCountrySelect(country?.[1]?.isoCode)}
                                        />
                                        {country?.[1]?.name}
                                    </label>
                                </div>
                            ))}
                        </div>
                    </div>
                )}


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
